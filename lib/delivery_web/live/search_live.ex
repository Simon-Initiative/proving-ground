defmodule DeliveryWeb.SearchLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="ui fluid category search">
      <div class="ui icon input">
        <form phx-change="suggest">
          <input class="prompt" type="text" name="q" value="<%= @query %>" placeholder="Search...">
          <i class="search icon"></i>
        </form>
      </div>
      <%= if @has_results do %>
        <div class="results transition" style="display: block !important;">
          <%= for category <- @categories do %>
            <div class="category">
              <div class="name"><%= category.name %></div>
              <div class="results">

                <%= for result <- category.results do %>
                  <a class="result">
                    <div class="content">
                      <div class="title"><%= result.title %></div>
                      <div class="description"><%= result.details %></div>
                    </div>
                  </a>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, query: nil, loading: false, has_results: false, categories: [])}
  end

  def handle_event("suggest", %{"q" => query}, socket) when byte_size(query) <= 100 do
    IO.puts "suggest"

    {:ok, %{rows: activity_rows, num_rows: a_rows }} = Ecto.Adapters.SQL.query(
      Delivery.Repo, "SELECT title, type FROM activities WHERE to_tsvector(title || ' ' || draft_content) @@ to_tsquery($1) LIMIT 5;", [query])

    {:ok, %{rows: package_rows, num_rows: p_rows }} = Ecto.Adapters.SQL.query(
        Delivery.Repo, "SELECT title, description FROM packages WHERE to_tsvector(title || ' ' || description) @@ to_tsquery($1) LIMIT 5;", [query])

    {:ok, %{rows: user_rows, num_rows: u_rows }} = Ecto.Adapters.SQL.query(
        Delivery.Repo, "SELECT concat(first_name,' ',last_name) \"name\", email FROM users WHERE to_tsvector(first_name || ' ' || last_name || ' ' || email) @@ to_tsquery($1) LIMIT 5;", [query])

    categories = [
      %{:name => "Packages", :results => activity_rows, :count => p_rows } ,
      %{:name => "Activities", :results => package_rows, :count => a_rows },
      %{:name => "Users", :results => user_rows, :count => u_rows },
    ] |> Enum.filter(fn m -> m[:count] > 0 end)

    {:noreply, assign(socket, categories: categories) }
  end

end
