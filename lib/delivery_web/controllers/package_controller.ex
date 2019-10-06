defmodule DeliveryWeb.PackageController do
  use DeliveryWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    live_render(conn, PackageLive.Index, session: %{
      start: get_session(conn, :start),
    })
  end
end
