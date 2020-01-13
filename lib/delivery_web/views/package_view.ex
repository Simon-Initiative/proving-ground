defmodule DeliveryWeb.PackageView do
  use DeliveryWeb, :view
  alias DeliveryWeb.PackageLive
  import Logger

  def parse_step(step) when is_binary(step), do: String.to_integer(step)
  def parse_step(step), do: step

  def previous_step(step) do
    case parse_step(step) do
      int when int > 1 -> int - 1
      _ -> 1
    end
  end

  def progress(step, total_steps) do
    (String.to_integer(step) / String.to_integer(total_steps) * 100)
    |> trunc()
  end
end
