defmodule DeliveryWeb.PackageController do
  use DeliveryWeb, :controller

  alias Delivery.Packages
  alias Delivery.Activities
  alias DeliveryWeb.Utils.HTML

  def index(conn, _params) do
    packages = Packages.list_packages()
    render(conn, "index.html", packages: packages)
  end

  def show(conn, %{"id" => id }) do
    package = Packages.get_package!(id)
    activities = Activities.list_activities_for(id)
    render(conn, "show.html", package: package, activities: activities)
  end

  def delete(conn, %{"id" => id}) do
    package = Packages.get_package!(id)
    {:ok, _activity} = Packages.delete_package(package)

    conn
    |> put_flash(:info, "Package deleted successfully.")
    |> redirect(to: Routes.package_path(conn, :index, id))
  end

  def qa_results(id, check) do

    IO.inspect id
    sql = case check do
      "links" ->
        """
        SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "link")') FROM activities WHERE package_id = $1;
        """
      "images_alt" ->
        """
        SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "image")') FROM activities WHERE package_id = $1;
        """
      "images" ->
        """
        SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "image")') FROM activities WHERE package_id = $1;
        """
      "tables" ->
        """
        SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "table")') FROM activities WHERE package_id = $1;
        """
      "youtube" ->
        """
        SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "youtube")') FROM activities WHERE package_id = $1;
        """
      "code" ->
        """
        SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "code")') FROM activities WHERE package_id = $1;
        """
    end

    {:ok, %{rows: results }} = Ecto.Adapters.SQL.query(
        Delivery.Repo, sql, [id])

    IO.puts "qa"
    IO.inspect results

    results = Enum.take_every(results, 2)

    Enum.map(results, fn r -> %{ id: Enum.at(r, 0), title: Enum.at(r, 1), element: Enum.at(r, 2) |> HTML.to_html()} end)
  end

  def qa(conn, %{"id" => id, "type" => check}) do
    package = Packages.get_package!(id)

    results = case check do
      "start" -> []
      _ -> qa_results(package.id, check)
    end

    render(conn, "qa.html", package: package, results: results, check: check)
  end

end
