defmodule DeliveryWeb.NotificationLive do
  use Phoenix.LiveView

  alias DeliveryWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <%= if assigns.update_available and !assigns.dismissed do %>
      <div class="ui info message sticky">
        <i class="close icon"></i>
        <div class="header">
          <%= assigns.user.first_name %> <%= assigns.user.last_name %> just published a change to this page.
        </div>
        To see these changes now, <a onclick="location.reload()" href="#">refresh</a> your browser.
      </div>
    <% end %>
    """
  end

  def mount(%{:activity_id => id}, socket) do
    DeliveryWeb.Endpoint.subscribe("notification:" <> id)
    {:ok, assign(socket, update_available: false, dismissed: false, user: nil)}
  end

  def handle_event("dismiss", _, socket) do
    {:noreply, assign(socket, dismissed: true) }
  end

  def handle_info(%{:event => "publish", :payload => %{:user => user}}, socket) do
    {:noreply, assign(socket, update_available: true, user: user)}
  end

end
