defmodule Delivery.Content.Diff.CompareTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline

  alias Delivery.Content.Diff
  alias Delivery.Content.Compare

  def image(id, src) do
    %Block{type: "image", data: %{id: id, src: src}}
  end

  def p(id, text) when is_binary(text) do
    %Block{type: "paragraph", data: %{id: id}, nodes: [%Text{text: text}]}
  end

  def p(id, text) when is_list(text) do
    %Block{type: "paragraph", data: %{id: id}, nodes: text}
  end

  def example(id, contents) do
    %Block{type: "example", data: %{id: id}, nodes: contents}
  end

  test "one level changes" do

    doc_a = %Document{nodes: [
      image("1", "happy.jpg"),
      image("2", "sad.jpg"),
      p("3", "This is some text")
    ]}
    doc_b = %Document{nodes: [
      image("1", "happy.jpg"),
      p("3", "This is some edited"),
      p("4", "And some more")
    ]}

    {a, b} = Compare.compare(doc_a, doc_b)

    assert a == %Diff{changed: ["3"], moved: [], added: ["2"], removed: ["4"]}
    assert b == %Diff{changed: ["3"], moved: [], added: ["4"], removed: ["2"]}

  end

  test "node reparenting" do

    doc_a = %Document{nodes: [
      example("A", [
        image("1", "happy.jpg")
      ]),
      example("B", [])
    ]}
    doc_b = %Document{nodes: [
      example("A", []),
      example("B", [image("1", "happy.jpg")])
    ]}

    {a, b} = Compare.compare(doc_a, doc_b)

    assert a == %Diff{changed: [], moved: ["1"], added: [], removed: []}
    assert b == %Diff{changed: [], moved: ["1"], added: [], removed: []}

  end

  test "node reordering" do

    doc_a = %Document{nodes: [
      example("A", [
        image("1", "happy.jpg"),
        image("2", "happy.jpg")
      ]),
      example("B", [])
    ]}
    doc_b = %Document{nodes: [
      example("A", [
        image("2", "happy.jpg"),
        image("1", "happy.jpg")
      ]),
      example("B", [])
    ]}

    {a, b} = Compare.compare(doc_a, doc_b)

    assert a == %Diff{changed: [], moved: ["1", "2"], added: [], removed: []}
    assert b == %Diff{changed: [], moved: ["1", "2"], added: [], removed: []}

  end

end
