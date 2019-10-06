defmodule DeliveryWeb.TestLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <form phx-submit="suggest">
      <input type="text" name="q" value="<%= @query %>" placeholder="Search..."
             <%= if @loading, do: "readonly" %>/>

      <hr/>

      <button type="submit">Set it</button>

    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, query: nil, loading: false )}
  end

  def handle_event("suggest", %{"q" => query}, socket) when byte_size(query) <= 100 do
    {:noreply, socket }
  end

end
