defmodule Delivery.Ingestion.Pressbooks do
  alias Delivery.Content.Reader

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline
  alias Delivery.Content.Mark
  alias Delivery.Content.Module
  alias Delivery.Content.Reference
  alias Delivery.Content.Organization

  @behaviour Reader

  def segment(input) do
    parsed = Floki.parse(input)

    {:ok,
     %{
       pages: parsed |> Floki.find("div[class=\"chapter standard\"]"),
       toc: parsed |> Floki.find("div[id=\"toc\"]") |> hd
     }}
  end

  def get_attr_by_key(items, key, def) do
    case Enum.find(items, {nil, def}, fn {k, _} -> k == key end) do
      {_, value} -> value
    end
  end

  def get_div_by_class(items, class) do
    case Enum.find(items, nil, fn {_, a, _} -> get_attr_by_key(a, "class", "") == class end) do
      {_, _, c} -> c
      nil -> []
    end
  end

  def organization(root) do
    modules =
      Floki.find(root, "li")
      |> Enum.reduce([], fn item, acc ->
        parsed =
          case item do
            {"li", [{"class", "part"}], [{"a", [{"href", "#" <> id}], [title]}]} ->
              %Module{id: id, title: title}

            {"li", [{"class", "chapter standard"}], [{"a", [{"href", "#" <> id}], _}]} ->
              %Reference{id: id}

            _ ->
              :ignore
          end

        case parsed do
          :ignore ->
            acc

          %Module{} = m ->
            [m] ++ acc

          %Reference{} = r ->
            case acc do
              [hd | rest] -> [%{hd | nodes: hd.nodes ++ [r]}] ++ rest
            end
        end
      end)
      |> Enum.reverse()

    %Organization{nodes: modules}
  end

  def page({"div", attributes, children}) do
    id = get_attr_by_key(attributes, "id", "unknown")
    title = get_attr_by_key(attributes, "title", "unknown")

    content_nodes =
      get_div_by_class(children, "ugc chapter-ugc")
      |> Enum.map(fn n -> handle(n) end)

    licensing_nodes =
      get_div_by_class(children, "licensing")
      |> Enum.map(fn n -> handle(n) end)

    %Document{
      data: %{id: id, title: title},
      nodes: content_nodes ++ licensing_nodes
    }
    |> clean()
  end

  def clean(%Document{} = doc) do
    nodes =
      List.flatten(doc.nodes)
      |> Enum.map(fn n ->
        case n do
          n when is_binary(n) -> %Block{nodes: [%Text{text: n}], type: "paragraph"}
          %{object: "text"} -> %Block{nodes: [n], type: "paragraph"}
          nil -> %Block{nodes: [%Text{text: ""}], type: "paragraph"}
          n -> n
        end
      end)

    %Document{
      data: doc.data,
      nodes: Enum.map(nodes, fn c -> clean(c) end)
    }
  end

  def clean(%Block{} = block) do
    no_markup = fn b ->
      %{b | marks: []}
    end

    collapse = fn b ->
      Enum.map(b.nodes, fn n -> clean(n) end)
    end

    check = fn b ->
      cond do
        is_binary(b) ->
          %Text{text: b}

        b.object == "block" and b.type == "paragraph" and block.type == "paragraph" ->
          collapse.(b)

        b.object == "block" and b.type == "paragraph" and block.type == "blockquote" ->
          collapse.(b)

        block.type == "codeblock" and b.object == "text" and length(b.marks) > 0 ->
          no_markup.(b)

        true ->
          clean(b)
      end
    end

    nodes = List.flatten(block.nodes)

    %Block{
      type: block.type,
      data: block.data,
      nodes:
        Enum.reduce(nodes, [], fn c, acc ->
          case check.(c) do
            item when is_list(item) -> acc ++ item
            scalar -> acc ++ [scalar]
          end
        end)
    }
  end

  def clean(other) do
    other
  end

  def extract_id(attributes) do
    case attributes do
      [{"id", id}] -> %{id: id}
      _ -> %{}
    end
  end

  def extract(attributes) do
    Enum.reduce(attributes, %{}, fn {k, v}, m -> Map.put(m, k, v) end)
  end

  def handle({"div", _attributes, children}) do
    case children do
      [{"ul", _, c}] ->
        %Block{type: "unordered-list", nodes: Enum.map(c, fn c -> handle(c) end)}

      [{"ol", _, c}] ->
        %Block{type: "ordered-list", nodes: Enum.map(c, fn c -> handle(c) end)}

      [{"h1", _, _} | _] ->
        Enum.map(children, fn c -> handle(c) end)

      [{"h2", _, _} | _] ->
        Enum.map(children, fn c -> handle(c) end)

      [{"h3", _, _} | _] ->
        Enum.map(children, fn c -> handle(c) end)

      [{"h4", _, _} | _] ->
        Enum.map(children, fn c -> handle(c) end)

      [{"h5", _, _} | _] ->
        Enum.map(children, fn c -> handle(c) end)

      [{"h6", _, _} | _] ->
        Enum.map(children, fn c -> handle(c) end)

      [{"div", _, [{"div", _, [{"div", _, c}]}]}] ->
        Enum.map(c, fn c -> handle(c) end)

      [{"div", _, [{"div", _, c} | more]} | rest] ->
        Enum.map(c ++ more ++ rest, fn c -> handle(c) end)

      [{"div", [{"class", "textbox tryit"}], c}] ->
        %Block{type: "paragraph", nodes: Enum.map(c, fn c -> handle(c) end)}

      [{"div", _, c} | rest] ->
        Enum.map(c ++ rest, fn c -> handle(c) end)

      [{"p", _, _} | _] ->
        Enum.map(children, fn c -> handle(c) end)

      c ->
        %Block{type: "paragraph", nodes: Enum.map(c, fn c -> handle(c) end)}
    end
  end

  def handle({"p", attributes, children}) do
    %Block{
      type: "paragraph",
      data: extract_id(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"small", _, [child]}) do
    handle(child)
  end

  def handle({"cite", _, [child]}) do
    handle(child)
  end

  def handle({"pre", _, children}) do
    %Block{
      type: "codeblock",
      data: %{"syntax" => "text"},
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"hr", _, _}) do
    %Block{
      type: "paragraph",
      nodes: []
    }
  end

  def handle({"ul", attributes, children}) do
    %Block{
      type: "unordered-list",
      data: extract_id(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"ol", attributes, children}) do
    %Block{
      type: "ordered-list",
      data: extract_id(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"li", attributes, children}) do
    %Block{
      type: "list-item",
      data: extract_id(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"h1", _, children}) do
    %Block{
      type: "heading-one",
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"h2", _, children}) do
    %Block{
      type: "heading-two",
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"h3", _, children}) do
    %Block{
      type: "heading-three",
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"h4", _, children}) do
    %Block{
      type: "heading-four",
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"h5", _, children}) do
    %Block{
      type: "heading-five",
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"table", attributes, children}) do
    %Block{
      type: "table",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"thead", attributes, children}) do
    %Block{
      type: "thead",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"tbody", attributes, children}) do
    %Block{
      type: "tbody",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"tfoot", attributes, children}) do
    %Block{
      type: "tfoot",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"caption", attributes, children}) do
    %Block{
      type: "caption",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"tr", attributes, children}) do
    %Block{
      type: "tr",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"td", attributes, children}) do
    %Block{
      type: "td",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"th", attributes, children}) do
    %Block{
      type: "th",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"img", attributes, children}) do
    %Block{
      type: "image",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"blockquote", attributes, [{"p", _, c}]}) do
    %Block{
      type: "blockquote",
      data: extract(attributes),
      nodes: Enum.map(c, fn c -> handle(c) end)
    }
  end

  def handle({"blockquote", attributes, [{"p", _, _} | _tail] = children}) do
    nodes = Enum.flat_map(children, fn {_, _, c} -> c end)

    %Block{
      type: "blockquote",
      data: extract(attributes),
      nodes: Enum.map(nodes, fn c -> handle(c) end)
    }
  end

  def handle({"blockquote", attributes, children}) do
    %Block{
      type: "blockquote",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"a", attributes, children}) do
    %Inline{
      type: "link",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
    }
  end

  def handle({"script", _, _}) do
    %Text{
      text: "script removed"
    }
  end

  def handle({"textarea", _, _}) do
    %Text{
      text: "textarea removed"
    }
  end

  def handle({"em", _, [text]}) when is_binary(text) do
    %Text{
      text: text,
      marks: [%Mark{type: "italic"}]
    }
  end

  def handle({"em", _, [{"a", _, _} = inline]}) do
    handle(inline)
  end

  def handle({"em", _, [item]}) when is_tuple(item) do
    inner = handle(item)

    %Text{
      text: inner.text,
      marks: [%Mark{type: "italic"}] ++ inner.marks
    }
  end

  def handle({"em", _, text}) do
    %Text{
      text: span(text),
      marks: [%Mark{type: "bold"}]
    }
  end

  def handle({"strong", _, [{"br", [], []}]}) do
    %Text{
      text: ""
    }
  end

  def handle({"strong", _, text}) do
    %Text{
      text: span(text),
      marks: [%Mark{type: "bold"}]
    }
  end

  def handle({"b", _, text}) do
    %Text{
      text: span(text),
      marks: [%Mark{type: "bold"}]
    }
  end

  def handle({"i", _, text}) do
    %Text{
      text: span(text),
      marks: [%Mark{type: "italic"}]
    }
  end

  def handle({"sub", _, text}) do
    %Text{
      text: span(text),
      marks: [%Mark{type: "sub"}]
    }
  end

  def handle({"sup", _, text}) do
    %Text{
      text: span(text),
      marks: [%Mark{type: "sup"}]
    }
  end

  def handle({"span", _, children}) do
    span(children)
  end

  def handle({"br", [], []}) do
    ""
  end

  def handle(text) when is_binary(text) do
    %Text{
      text: text
    }
  end

  def handle(unsupported) do
    IO.puts("Unsupported")
    IO.inspect(unsupported)
  end

  def span({_, _, children}) when is_list(children) do
    Enum.map(children, fn c -> span(c) end)
    |> Enum.join(" ")
  end

  def span({_, _, text}) when is_binary(text) do
    text
  end

  def span(list) when is_list(list) do
    Enum.map(list, fn c -> span(c) end)
    |> Enum.join(" ")
  end

  def span(text) when is_binary(text) do
    text
  end

  def determine_type(input) do
  end
end
