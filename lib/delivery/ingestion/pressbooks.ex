defmodule Delivery.Ingestion.Pressbooks do
  alias Delivery.Ingestion.Ingest

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline
  alias Delivery.Content.Mark

  @behaviour Ingest

  def segment(input) do
    {:ok,
     Floki.parse(input)
     |> Floki.find("div[class=\"chapter standard\"]")}
  end

  def parse({"div", _attributes, children}) do
    {_, _, chapter} = Enum.at(children, 1)

    %Document{nodes: Enum.map(chapter, fn c -> handle(c) end)}
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
      [{"ul", _, c}] -> %Block{type: "unordered-list", nodes: Enum.map(c, fn c -> handle(c) end)}
      [{"ol", _, c}] -> %Block{type: "ordered-list", nodes: Enum.map(c, fn c -> handle(c) end)}
      c -> %Block{type: "paragraph", nodes: Enum.map(c, fn c -> handle(c) end)}
    end
  end

  def handle({"p", attributes, children}) do
    %Block{
      type: "paragraph",
      data: extract_id(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
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
      type: "img",
      data: extract(attributes),
      nodes: Enum.map(children, fn c -> handle(c) end)
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

  def handle({"em", [{"class", "emphasis"}], [text]}) do
    %Text{
      text: text,
      marks: [%Mark{type: "italic"}]
    }
  end

  def handle({"em", _, [text]}) do
    %Text{
      text: text,
      marks: [%Mark{type: "bold"}]
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
