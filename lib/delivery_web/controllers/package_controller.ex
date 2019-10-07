defmodule DeliveryWeb.PackageController do
  use DeliveryWeb, :controller

  import Phoenix.LiveView.Controller

  alias Delivery.Packages
  alias Delivery.Packages.Package

  def index(conn, _params) do
    packages = Packages.list_packages()
    render(conn, "index.html", packages: packages)
  end

  def show(conn, %{"id" => id }) do
    package = Packages.get_package!(id)
    render(conn, "show.html", package: package)
  end

  def delete(conn, %{"id" => id}) do
    package = Packages.get_package!(id)
    {:ok, _activity} = Packages.delete_package(package)

    conn
    |> put_flash(:info, "Package deleted successfully.")
    |> redirect(to: Routes.package_path(conn, :index, id))
  end
end
