defmodule Delivery.Ingestion.Pressbooks do

  alias Delivery.Ingestion.Ingest

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline
  alias Delivery.Content.Mark

  @behaviour Ingest

  def segment(input) do
    {:ok, Floki.parse(input)
      |> Floki.find("div[class=\"chapter standard\"]")}
  end

  def parse({"div", attributes, children}) do
    %Document{nodes: Enum.map(children, fn c -> handle(c) end)}
  end

  def extract_id(attributes) do
    case attributes do
      [{"id", id}] -> %{id: id}
      _ -> %{}
    end
  end

  def div_list?(children) do
    Enum.any?(children, fn c -> case c do
      {"ul", _, _} -> True
      {"ol", _, _} -> True
      _ -> False
    end end)
  end

  def handle({"div", attributes, children}) do
    case children do
      [{"ul", _, c}] -> %Block{type: "unordered-list", nodes: Enum.map(c, fn c -> handle(c) end)}
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

  def handle({"em", [{"class", "emphasis"}], [text]}) do
    %Text{
      text: text,
      marks: [%Mark{type: "italic"}]
    }
  end

  def handle({"em", [], [text]}) do
    %Text{
      text: text,
      marks: [%Mark{type: "bold"}]
    }
  end


  def handle({"strong", [], [text]}) do
    %Text{
      text: text,
      marks: [%Mark{type: "bold"}]
    }
  end

  def handle(text) when is_binary(text) do
    %Text{
      text: text
    }
  end

  def handle(unsupported) do
    IO.puts "Unsupported"
    IO.inspect(unsupported)
  end




  def determine_type(input) do

  end
end

