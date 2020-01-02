defmodule DeliveryWeb.PackageController do
  use DeliveryWeb, :controller

  alias Delivery.Packages
  alias Delivery.Activities
  alias Delivery.Objectives
  alias Delivery.Objectives.Objective
  alias Delivery.Repo

  def index(conn, _params) do
    packages = Packages.list_packages()
    render(conn, "index.html", packages: packages)
  end

  def show(conn, %{"id" => id}) do
    package = Packages.get_package!(id)
    activities = Activities.list_activities_for(id)
    objectives = Repo.preload(Objectives.list_objectives_for(id), :skills)

    render(conn, "show.html",
      package: package,
      activities: activities,
      objectives: objectives
    )
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    package = Packages.get_package!(id)
    {:ok, _activity} = Packages.delete_package(package)

    conn
    |> put_flash(:info, "Package deleted successfully.")
    |> redirect(to: Routes.package_path(conn, :index, id))
  end
end
