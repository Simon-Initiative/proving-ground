defmodule DeliveryWeb.PageController do
  use DeliveryWeb, :controller
  alias Delivery.Activities


  def write(conn, %{"nodes" => nodes, "id" => id}) do

    activity = Activities.get_activity!(id)

    case Activities.update_activity(activity, %{draft_content: %{ nodes: nodes }, is_draft: true}) do
      {:ok, _activity} -> json(conn, %{ saved: True })
      {:error, _changeset} -> json(conn, %{ saved: False })
    end

  end

  def show(conn, %{"id" => id}) do

    a = Activities.get_activity!(id)

    render(conn, "index.html", id: a.id, title: a.title, content: Poison.encode!(a.draft_content))
  end

end
