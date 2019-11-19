defmodule Delivery.Content.Block do
  defstruct nodes: [], type: "paragraph", object: "block", data: %{}

end

defimpl ContentHash, for: Delivery.Content.Block do
  def hash(block) do

    data =
      Enum.map(Map.keys(block.data), fn k -> [Atom.to_string(k), Map.get(block.data, k)] end)
      ++ (
        Enum.filter(block.nodes, fn b -> b.object !== "block" end)
        |> Enum.map(&ContentSerialize.iodata/1))

    :crypto.hash(:sha256, data)
  end
end
