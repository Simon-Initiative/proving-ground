defmodule Delivery.Content.PressBooksTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline
  alias Delivery.Ingestion.Pressbooks

  alias DeliveryWeb.Utils.Renderer
  alias DeliveryWeb.Utils.XML

  @out_path "./test/delivery/content/test_out"

  def read_from_file(file) do
    File.read!(file)
  end

  def pressbook_to_workbook({segment, index}) do
    parsed = Pressbooks.parse(segment)

    File.write!(@out_path <> "/#{index}.json", Poison.encode!(parsed))

    xml = Renderer.render(parsed, XML)

    File.write!(@out_path <> "/#{index}.xml", xml)
  end

  setup do
    File.rm_rf(@out_path)
    File.mkdir(@out_path)
    []
  end

  test "converting all" do
    input = read_from_file("./test/delivery/content/amlit.html")

    segments =
      case Pressbooks.segment(input) do
        {:ok, segments} -> segments
      end

    Enum.with_index(segments)
    |> Enum.map(fn s -> pressbook_to_workbook(s) end)

    # IO.inspect(Enum.at(segments, 37))

    # s = Enum.at(segments, 37)
    # pressbook_to_workbook({s, 37})
  end
end
