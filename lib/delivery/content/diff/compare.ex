defmodule Delivery.Content.Compare do
  alias Delivery.Content.Diff
  alias Delivery.Content.Diff.BlockSummary
  alias Delivery.Content.Document
  alias Delivery.Content.Block
  alias Delivery.Content.Inline
  alias Delivery.Content.Text

  defp flatten(%Document{nodes: nodes}) do
    Enum.with_index(nodes)
    |> Enum.reduce(%{}, fn {b, index}, acc -> flatten(b, acc, nil, index) end)
  end

  defp flatten(%Block{nodes: nodes} = block, map, parent_id, index) do
    id = block.data.id

    has_text =
      case block.nodes do
        [%Text{} | _] -> true
        [%Inline{} | _] -> true
        _ -> false
      end

    map =
      Map.put(map, id, %BlockSummary{
        id: id,
        parent_id: parent_id,
        index: index,
        block: block,
        has_text: has_text,
        hash: ContentHash.hash(block)
      })

    nodes
    |> Enum.filter(fn n -> n.object == "block" end)
    |> Enum.with_index()
    |> Enum.reduce(map, fn {b, index}, acc -> flatten(b, acc, id, index) end)
  end

  defp reorderings(%BlockSummary{} = a, %BlockSummary{} = b) do
    # For block summary a and b, get the ids of only the block nodes
    # in their nodes collection
    nodes_a =
      Enum.filter(a.block.nodes, fn n -> n.object == "block" end)
      |> Enum.map(fn b -> b.data.id end)

    nodes_b =
      Enum.filter(b.block.nodes, fn n -> n.object == "block" end)
      |> Enum.map(fn b -> b.data.id end)

    # Convert the list of ids to sets
    set_a = MapSet.new(nodes_a)
    set_b = MapSet.new(nodes_b)

    # Find the elements that exist in both
    same = MapSet.intersection(set_a, set_b)

    # Filter out the original list of ids, leaving only the items that
    # exist in both
    a = nodes_a |> Enum.filter(fn id -> MapSet.member?(same, id) end)
    b = nodes_b |> Enum.filter(fn id -> MapSet.member?(same, id) end)

    # Now compare the orderings of these items, pairwise
    Enum.zip(a, b)
    |> Enum.filter(fn {a, b} -> a != b end)
    |> Enum.map(fn {_, b} -> b end)
  end

  @doc "
  Performs a three way merge from a source document into a target document,
  given their common ancestor document. This routine will automatically migrate
  the changes that have been made from ancestor to src into target. It will flag
  cases where a conflict is detected that a human must resolve manually.
  "
  def three_way_merge(%Document{} = src, %Document{} = target, %Document{} = ancestor) do
    # First calculate the diffs between the ancestor and each of the src
    # and target documents.
    diff_src = compare(ancestor, src)
    diff_target = compare(ancestor, target)

    # For all changed blocks in src that exist in target and are unchanged in target,
    # simply replace the target block with src block

    # For new subtrees in src, verify that the parent block still exists in target
    # and insert the subtree into the same index - or at the end - of that parent's nodes

    # For removed subtrees in src, verify that the parent still exists in target and that
    # none of the nodes in target (if they exist) have been changed.  If any have been
    # changed we flag the entire removal as a conflict

    # For reordered blocks in src, verify that the indexes of these blocks is the same in
    # target before applying the change in target

    # For moved blocks, verify that the block in target still has the same parent
  end

  @doc "
  Compares version b of a document against previous version a.
  "
  def compare(%Document{} = a, %Document{} = b) do
    # First flatten the hierarchical model of each document down to
    # a map of the block ids to the the blocks
    sum_a = flatten(a)
    sum_b = flatten(b)

    # Create a set for each set of block ids
    keys_a = MapSet.new(Map.keys(sum_a))
    keys_b = MapSet.new(Map.keys(sum_b))

    # The blocks that have 'changed' are those that exist in both
    # sets but that have different hash values
    changed =
      MapSet.intersection(keys_a, keys_b)
      |> Enum.filter(fn id -> Map.get(sum_a, id).hash != Map.get(sum_b, id).hash end)

    # We can find added and removed blocks by simply doing a set difference
    added = MapSet.difference(keys_a, keys_b) |> Enum.to_list()
    removed = MapSet.difference(keys_b, keys_a) |> Enum.to_list()

    # We consider 'moved' blocks to be blocks that now have a new parent
    moved =
      Enum.filter(keys_a, fn id ->
        a = Map.get(sum_a, id)
        b = Map.get(sum_b, id, a)
        a.parent_id != b.parent_id
      end)

    # Reordered blocks are those that have the same parent, but that are in a
    # new order. We need to ignore any removed or added nodes, otherwise all
    # nodes after an addition or removal would appear to be "reordered" since
    # they would be at a new ordinal position. To do this we perform this
    # calculation blockwise but only consider nodes that are in both versions
    # of each block.
    reordered =
      Enum.reduce(keys_b, [], fn id, arr ->
        block_b = Map.get(sum_b, id)
        block_a = Map.get(sum_a, id)

        case block_a do
          nil -> arr
          _ -> arr ++ reorderings(block_a, block_b)
        end
      end)

    %Diff{
      block_map: sum_b,
      added: added,
      removed: removed,
      changed: changed,
      moved: moved,
      reordered: reordered
    }
  end
end
