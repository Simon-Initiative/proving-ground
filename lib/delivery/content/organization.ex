defmodule Delivery.Content.Organization do
  defstruct nodes: [], object: "organization", id: "default_org", title: "Default organization"

  defimpl Inspect do
    def inspect(%Delivery.Content.Organization{nodes: nodes}, _) do
      n =
        Enum.map(nodes, fn a -> a.type end)
        |> Enum.join("\n")

      "<Organization>: #{n} top-level nodes"
    end
  end
end
