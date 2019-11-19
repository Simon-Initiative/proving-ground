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


  def compare(%Document{} = a, %Document{} = b) do

    sum_a = flatten(a)
    sum_b = flatten(b)

    keys_a = MapSet.new(Map.keys(sum_a))
    keys_b = MapSet.new(Map.keys(sum_b))

    changed = MapSet.intersection(keys_a, keys_b)
      |> Enum.filter(fn id -> Map.get(sum_a, id).hash != Map.get(sum_b, id).hash end)

    added_a = MapSet.difference(keys_a, keys_b) |> Enum.to_list
    added_b = MapSet.difference(keys_b, keys_a) |> Enum.to_list

    moved = fn keys, map1, map2 ->
      Enum.filter(keys, fn id ->
        a = Map.get(map1, id)
        b = Map.get(map2, id, a)
        a.parent_id != b.parent_id or a.index != b.index
      end)
    end

    moved_a = moved.(keys_a, sum_a, sum_b)
    moved_b = moved.(keys_b, sum_b, sum_a)

    {
      %Diff{added: added_a, removed: added_b, changed: changed, moved: moved_a},
      %Diff{added: added_b, removed: added_a, changed: changed, moved: moved_b}
    }
  end
end
