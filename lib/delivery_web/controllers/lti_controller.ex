defmodule DeliveryWeb.LTIController do
  use DeliveryWeb, :controller

  alias Delivery.LTI

  def basic_launch(conn, _params) do
    render(conn, "basic_launch.html")
  end

end
