defmodule DeliveryWeb.NotificationChannel do
  use Phoenix.Channel


  def join("notification:" <> _activity_id, _message, socket) do
    {:ok, socket}
  end

  def join(_room, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("publish", %{"user" => user}, socket) do
    broadcast!(socket, "publish", %{user: user, when: DateTime.utc_now()})
    {:noreply, socket}
  end

end
