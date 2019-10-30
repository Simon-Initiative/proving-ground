defmodule Delivery.Content.Document do
  defstruct nodes: [], object: "document", data: %{}

  defimpl Inspect do
    def inspect(%Delivery.Content.Document{nodes: nodes}, _) do
      n =
        Enum.map(nodes, fn a -> a.type end)
        |> Enum.join("\n")

      "<Document>: #{n} top-level nodes"
    end
  end
end
