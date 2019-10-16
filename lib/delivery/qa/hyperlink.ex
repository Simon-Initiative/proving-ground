defmodule Delivery.QA.Hyperlink do

  alias Delivery.Utils.Parallel

  def validate_links(links) when is_list(links) do
    Parallel.map(links, fn link -> validate(link) end)
  end

  defp validate(link) do

    element = Map.get(link, :raw)
    data = Map.get(element, "data")
    href = Map.get(data, "href")

    status = case HTTPoison.head(href) do
      {:ok, _} -> true
      _ -> false
    end

    %{ link | status: status }
  end

end
