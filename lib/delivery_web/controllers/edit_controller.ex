defmodule DeliveryWeb.EditController do
  use DeliveryWeb, :controller
  alias Delivery.Activities


  def write(conn, %{"nodes" => nodes, "id" => id}) do

    activity = Activities.get_activity!(id)

    IO.puts extract_text(nodes, "")

    case Activities.update_activity(activity, %{draft_content: %{ nodes: nodes }}) do
      {:ok, _activity} -> json(conn, %{ saved: True })
      {:error, _changeset} -> json(conn, %{ saved: False })
    end

  end

  def show(conn, %{"id" => id}) do

    a = Activities.get_activity!(id)

    render(conn, "index.html", id: a.id, title: a.title, content: Poison.encode!(a.draft_content))
  end

  @spec extract_text(maybe_improper_list | map, any) :: any
  def extract_text(%{"nodes" => nodes }, text) do
    extract_text(nodes, text)
  end

  def extract_text(nodes, text) when is_list(nodes) do
    Enum.reduce(nodes, text, fn n, acc -> extract_text(n, acc) end)
  end

  def extract_text(%{"text" => text}, acc) do
    acc <> text <> " "
  end


end
