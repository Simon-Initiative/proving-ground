defmodule Delivery.Content.GenTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline

  alias Delivery.Content.Schema.V1
  alias Delivery.Content.Schema.V1.Paragraph
  alias Delivery.Content.Schema.V1.Image

  test "converting all" do
    V1.as_schema()
    V1.as_typescript()
    test = %Paragraph{id: "yes"}

    %Image{src: "test", src: "test"}

    IO.inspect(test)
  end
end
