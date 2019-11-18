defmodule Delivery.Content.Block do
  defstruct nodes: [], type: "paragraph", object: "block", data: %{}

end

defimpl ContentHash, for: Block do
  def hash(block) do

    data =
      Enum.map(Map.keys(block.data), fn k -> [k, Map.get(block.data, k)] end)
      ++ (
        Enum.filter(block.nodes, fn b -> b.object !== "block" end)
        |> Enum.map(&ContentSerialize.iodata/1))

    :crypto.hash(:sha1, data)
  end
end
