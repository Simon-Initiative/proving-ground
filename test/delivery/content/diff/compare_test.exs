defmodule Delivery.Content.Diff.CompareTest do
  use ExUnit.Case, async: true

  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Text
  alias Delivery.Content.Inline

  alias Delivery.Content.Diff
  alias Delivery.Content.Compare

  def diff(a, b) when is_list(a) do
    List.myers_difference(a, b, &String.myers_difference/2)
  end

  def diff(a, b) when is_binary(a) do
    String.myers_difference(a, b)
  end

  def image(id, src) do
    %Block{type: "image", data: %{id: id, src: src}}
  end

  def p(id, text) when is_binary(text) do
    %Block{type: "paragraph", data: %{id: id}, nodes: [%Text{text: text}]}
  end

  def p(id, text) when is_list(text) do
    %Block{type: "paragraph", data: %{id: id}, nodes: text}
  end

  def text(text, marks) do
    %Text{text: text, marks: marks}
  end

  def link(nodes, src) do
    %Inline{nodes: nodes, data: %{src: src}}
  end

  def example(id, contents) do
    %Block{type: "example", data: %{id: id}, nodes: contents}
  end

  test "one level changes" do
    doc_a = %Document{
      nodes: [
        image("1", "happy.jpg"),
        image("2", "sad.jpg"),
        p("3", "This is some text")
      ]
    }

    doc_b = %Document{
      nodes: [
        image("1", "happy.jpg"),
        p("3", "This is some edited"),
        p("4", "And some more")
      ]
    }

    a = Compare.compare(doc_a, doc_b)

    assert a == %Diff{changed: ["3"], moved: [], added: ["2"], removed: ["4"]}
  end

  test "node reparenting" do
    doc_a = %Document{
      nodes: [
        example("A", [
          image("1", "happy.jpg")
        ]),
        example("B", [])
      ]
    }

    doc_b = %Document{
      nodes: [
        example("A", []),
        example("B", [image("1", "happy.jpg")])
      ]
    }

    a = Compare.compare(doc_a, doc_b)

    assert a == %Diff{changed: [], moved: ["1"], added: [], removed: []}
  end

  test "node reordering" do
    doc_a = %Document{
      nodes: [
        example("A", [
          image("1", "happy.jpg"),
          image("2", "happy.jpg")
        ]),
        example("B", [])
      ]
    }

    doc_b = %Document{
      nodes: [
        example("A", [
          image("2", "happy.jpg"),
          image("1", "happy.jpg")
        ]),
        example("B", [])
      ]
    }

    a = Compare.compare(doc_a, doc_b)

    assert a == %Diff{changed: [], reordered: ["2", "1"], added: [], removed: [], moved: []}
  end

  test "text compare" do
  end
end
