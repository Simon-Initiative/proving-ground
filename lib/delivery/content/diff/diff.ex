defmodule Delivery.Content.Diff do
  defstruct removed: [], added: [], moved: [], changed: []

  alias Delivery.Content.Diff.BlockSummary
  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Inline
  alias Delivery.Content.Text


  def summarize(%Document{nodes: nodes} = doc) do

    Enum.reduce(nodes, %{}, fn b, acc ->
      id = Map.get(b.data, "id")
      Map.put(acc, id, %BlockSummary{id: id, parent_id: nil, block: b, hash: ContentHash.hash(b)})
    end)
  end

  def summarize(%Block{nodes: nodes} = block) do

  end

  def summarize(%Inline{nodes: nodes} = inline) do

  end

  def summarize(%Text{} = text) do

  end

  def summarize(nodes) when is_list(nodes) do
    Enum.map(nodes, fn n -> flatten(n) end)
  end

end
