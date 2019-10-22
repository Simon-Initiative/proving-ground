defmodule DeliveryWeb.Utils.Renderer do
  alias DeliveryWeb.Utils.Types

  @type next :: (() -> String.t())
  @type nodes :: [%{}]

  @callback paragraph(next, %Types{}) :: String.t()

  @callback text(next, {:text, String.t()}, {:marks, [String.t()]}) :: String.t()
end
