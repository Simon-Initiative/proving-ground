defmodule DeliveryWeb.DiscreteComponentsController do
  use DeliveryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

end
