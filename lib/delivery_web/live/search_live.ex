defmodule DeliveryWeb.SearchLive do
  use Phoenix.LiveView

  alias DeliveryWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <div class="ui fluid category search item">
      <div class="ui icon input">
        <input class="prompt" type="text" phx-keyup="search" phx-throttle="500" placeholder="Search...">
        <i class="search icon"></i>
      </div>
      <%= if length(@categories) > 0 do %>
        <div class="results transition visible" style="display: block !important; z-index: 8000;">
          <%= for category <- @categories do %>
            <div class="category">
              <div class="name"><%= category.name %></div>
              <div class="results">

                <%= for result <- category.results do %>
                  <a class="result" href="<%= result.link %>">
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
    {:ok, assign(socket, query: nil, loading: false, categories: [])}
  end

  def handle_event("search", %{ "value" => value }, socket) do

    query = case String.contains?(String.trim(value), " ") do
      true -> String.trim(value) |> String.split |> Enum.join(" & ")
      false -> value
    end

    {:ok, %{rows: activity_rows, num_rows: a_rows }} = Ecto.Adapters.SQL.query(
      Delivery.Repo, "SELECT id, package_id, title, type FROM activities WHERE to_tsvector(title || ' ' || draft_content) @@ to_tsquery($1) LIMIT 5;", [query])

    {:ok, %{rows: package_rows, num_rows: p_rows }} = Ecto.Adapters.SQL.query(
        Delivery.Repo, "SELECT id, title, description FROM packages WHERE to_tsvector(title || ' ' || description) @@ to_tsquery($1) LIMIT 5;", [query])

    {:ok, %{rows: user_rows, num_rows: u_rows }} = Ecto.Adapters.SQL.query(
        Delivery.Repo, "SELECT id, concat(first_name,' ',last_name) \"name\", email FROM users WHERE to_tsvector(first_name || ' ' || last_name || ' ' || email) @@ to_tsquery($1) LIMIT 5;", [query])

    package_to_result = fn row -> %{ :link => Routes.package_path(DeliveryWeb.Endpoint, :show, hd(row)), :title => hd(tl(row)), :details => List.last(row) } end
    activity_to_result = fn row -> %{ :link => Routes.activity_path(DeliveryWeb.Endpoint, :show, Enum.at(row, 1), hd(row)), :title => Enum.at(row, 2), :details => List.last(row) } end
    user_to_result = fn row -> %{ :link => Routes.user_path(DeliveryWeb.Endpoint, :show, hd(row)), :title => hd(tl(row)), :details => List.last(row) } end

    categories = [
      %{:name => "Packages", :results => Enum.map(package_rows, package_to_result), :count => p_rows },
      %{:name => "Activities", :results => Enum.map(activity_rows, activity_to_result), :count => a_rows },
      %{:name => "Users", :results => Enum.map(user_rows, user_to_result), :count => u_rows },
    ] |> Enum.filter(fn m -> m[:count] > 0 end)

    {:noreply, assign(socket, categories: categories) }
  end

end
