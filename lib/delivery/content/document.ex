defmodule Delivery.Content.Document do
  defstruct nodes: [], object: "document", data: %{}

  defimpl Inspect do
    def inspect(%Delivery.Content.Document{nodes: nodes}, _) do
      "<Document>: #{length(nodes)} top-level nodes"
    end
  end

end
