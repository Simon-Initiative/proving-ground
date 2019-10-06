defmodule DeliveryWeb.PackageLive.Index do
  use Phoenix.LiveView

  alias Delivery.Packages
  alias DeliveryWeb.PackageView

  def mount(_session, socket) do
    {:ok, fetch(socket) }
  end

  def render(assigns), do: PackageView.render("index.html", assigns)

  defp fetch(socket) do
    assign(socket, packages: Packages.list_packages() )
  end

  def handle_event("delete_package", id, socket) do
    package = Packages.get_package!(id)
    {:ok, _package} = Packages.delete_package(package)
    {:noreply, fetch(socket) }
  end
end
