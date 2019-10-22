defmodule DeliveryWeb.Utils.Link do
  defstruct href: "", target: nil

  def href(map) do
    Map.get(map, "href")
  end
end
