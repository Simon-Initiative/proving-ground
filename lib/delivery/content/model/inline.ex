defmodule Delivery.Content.Inline do
  defstruct nodes: [], type: "link", object: "inline", data: %{}
end


defimpl ContentSerialize, for: Delivery.Content.Inline do
  def iodata(inline) do
    Enum.map(Map.keys(inline.data), fn k -> [k, Map.get(inline.data, k)] end)
    ++ Enum.map(inline.nodes, &ContentSerialize.iodata/1)
  end
end
