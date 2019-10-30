defmodule Delivery.Content.PressBooksTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline
  alias Delivery.Ingestion.Pressbooks

  describe "pressbooks" do
    def input_fixture() do
      html = """
        <html>
        <body>
          <div class="chapter standard"><div>one</div></div>
          <div class="chapter standard"><div>two</div></div>
          <div class="chapter standard"><div>three</div></div>
        </body>
        </html>
      """
    end

    def read_from_file(file) do
      File.read!(file)
    end

    test "reducing all" do
      input = read_from_file("./test/delivery/content/amlit.html")

      segments =
        case Pressbooks.segment(input) do
          {:ok, segments} -> segments
        end

      Enum.map(segments, fn s -> Pressbooks.parse(s) end)
    end
  end
end
