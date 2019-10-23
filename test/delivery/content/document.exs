defmodule Delivery.Content.DocumentTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline


  describe "users" do
    alias Delivery.Accounts.User

    def doc_fixture() do
      %Document{
        nodes: [
          %Block{nodes: [%Text{text: "This is paragraph one."}]},
          %Block{nodes: [%Inline{
            nodes: [%Text{text: "A link"}],
            type: "link",
          }, %Text{text: " inside of paragraph two."}]},
          %Block{nodes: [%Text{text: "This is paragraph three."}]},
        ]
      }
    end

    test "reducing all" do
      doc = doc_fixture()

      list = Enum.map(doc, fn n -> Map.put(n, :test, "test") end)
      IO.inspect(list)

    end

  end
end
