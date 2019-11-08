defmodule Delivery.Content.PressBooksTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline
  alias Delivery.Content.Readers.Pressbooks

  alias Delivery.Content.Writers.Writer
  alias Delivery.Content.Writers.Context
  alias Delivery.Content.Writers.XML

  @out_path "./test/delivery/content/test_out"

  def read_from_file(file) do
    File.read!(file)
  end

  def pressbook_to_workbook(segment) do
    parsed = Pressbooks.page(segment)
    id = Map.get(parsed.data, :id)
    xml = Writer.render(%Context{}, parsed, XML)

    # File.write!(@out_path <> "/content/x-oli-workbook_page/#{index}.json", Poison.encode!(parsed))
    File.write!(@out_path <> "/content/x-oli-workbook_page/#{id}.xml", xml)
  end

  def to_org(org) do
    parsed = Pressbooks.organization(org)

    # File.write!(@out_path <> "/organizations/default/organization.json", Poison.encode!(parsed))

    xml = Writer.render(%Context{}, parsed, XML)

    File.write!(@out_path <> "/organizations/default/organization.xml", xml)
  end

  setup do
    File.rm_rf(@out_path)
    File.mkdir(@out_path)
    File.mkdir(@out_path <> "/content")
    File.mkdir(@out_path <> "/content/x-oli-workbook_page")
    File.mkdir(@out_path <> "/organizations")
    File.mkdir(@out_path <> "/organizations/default")

    []
  end

  test "converting all" do
    input = read_from_file("./test/delivery/content/bio.html")

    {:ok, %{pages: pages, toc: toc}} = Pressbooks.segment(input)
    IO.inspect(Enum.at(pages, 0))

    Enum.map(pages, fn r -> r end)
    |> Enum.map(fn s -> pressbook_to_workbook(s) end)

    to_org(toc)
  end
end
