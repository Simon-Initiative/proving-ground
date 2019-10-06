defmodule DeliveryWeb.SearchLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <form phx-change="suggest">
      <input type="text" name="q" value="<%= @query %>" placeholder="Search..."
             <%= if @loading, do: "readonly" %>/>

      <hr/>

      <ul>
        <%= for match <- @matches do %>
          <li><%= match %></li>
         <% end %>
      </ul>
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, query: nil, loading: false, matches: [])}
  end

  def handle_event("suggest", %{"q" => query}, socket) when byte_size(query) <= 100 do
    IO.puts "suggest"
    {:ok, %{rows: rows }} = Ecto.Adapters.SQL.query(
      Delivery.Repo, "SELECT title FROM activities WHERE to_tsvector(title || ' ' || content) @@ to_tsquery($1) LIMIT 10;", [query])

    {:noreply, assign(socket, matches: rows) }
  end

end
