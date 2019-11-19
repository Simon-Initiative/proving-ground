defmodule Delivery.Content.Compare do

  alias Delivery.Content.Diff
  alias Delivery.Content.Diff.BlockSummary
  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Inline
  alias Delivery.Content.Text


  def flatten(%Document{nodes: nodes}) do
    Enum.with_index(nodes)
    |> Enum.reduce(%{}, fn {b, index}, acc -> flatten(b, acc, nil, index) end)
  end

  def flatten(%Block{nodes: nodes} = block, map, parent_id, index) do
    id = block.data.id
    map = Map.put(map, id, %BlockSummary{id: id, parent_id: parent_id, index: index, block: block, hash: ContentHash.hash(block)})

    nodes
    |> Enum.filter(fn n -> n.object == "block" end)
    |> Enum.with_index
    |> Enum.reduce(map, fn {b, index}, acc -> flatten(b, acc, id, index) end)
  end

  def reorderings(a, b) do

    nodes_a = Enum.filter(a.block.nodes, fn n -> n.object == "block" end) |> Enum.map(fn b -> b.data.id end)
    nodes_b = Enum.filter(b.block.nodes, fn n -> n.object == "block" end) |> Enum.map(fn b -> b.data.id end)

    set_a = MapSet.new(nodes_a)
    set_b = MapSet.new(nodes_b)

    same = MapSet.intersection(set_a, set_b)

    a = nodes_a |> Enum.filter(fn id -> MapSet.member?(same, id) end)
    b = nodes_b |> Enum.filter(fn id -> MapSet.member?(same, id) end)

    Enum.zip(a, b)
    |> Enum.filter(fn {a, b} -> a != b end)
    |> Enum.map(fn {_, b} -> b end)
  end

  def compare(%Document{} = a, %Document{} = b) do

    sum_a = flatten(a)
    sum_b = flatten(b)

    keys_a = MapSet.new(Map.keys(sum_a))
    keys_b = MapSet.new(Map.keys(sum_b))

    changed = MapSet.intersection(keys_a, keys_b)
      |> Enum.filter(fn id -> Map.get(sum_a, id).hash != Map.get(sum_b, id).hash end)

    added = MapSet.difference(keys_a, keys_b) |> Enum.to_list
    removed = MapSet.difference(keys_b, keys_a) |> Enum.to_list

    moved = Enum.filter(keys_a, fn id ->
        a = Map.get(sum_a, id)
        b = Map.get(sum_b, id, a)
        a.parent_id != b.parent_id
      end)

    reordered = Enum.reduce(keys_b, [], fn id, arr ->
      block_b = Map.get(sum_b, id)
      block_a = Map.get(sum_a, id)
      case block_a do
        nil -> arr
        _ -> arr ++ reorderings(block_a, block_b)
      end
    end)

    %Diff{added: added, removed: removed, changed: changed, moved: moved, reordered: reordered}
  end
end
