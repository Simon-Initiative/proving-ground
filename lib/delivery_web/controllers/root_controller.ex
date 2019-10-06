defmodule DeliveryWeb.RootController do
  use DeliveryWeb, :controller

  def index(conn, _params) do

    case get_session(conn, :start) do
      nil -> put_session(conn, :start, DateTime.utc_now()) |> render("index.html", start: get_session(conn, :start))
      value -> render(conn, "index.html", start: value)
    end

  end

end
