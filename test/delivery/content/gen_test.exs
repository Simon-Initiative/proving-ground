defmodule Delivery.Content.GenTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline

  alias Delivery.Content.Schema.V1
  alias Delivery.Content.Schema.V1.Paragraph


  test "converting all" do
    V1.as_typescript()
    test = %Paragraph{id: "yes"}
    IO.inspect test
  end
end
