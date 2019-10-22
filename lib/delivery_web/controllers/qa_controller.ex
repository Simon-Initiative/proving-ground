defmodule DeliveryWeb.QAController do
  use DeliveryWeb, :controller

  alias Delivery.Packages
  alias DeliveryWeb.Utils.HTML
  alias Delivery.QA.Hyperlink

  def query(conn, id, item) do
    sql =
      """
      SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "#{item}")') FROM activities WHERE package_id = $1;
      """

    {:ok, %{rows: results }} = Ecto.Adapters.SQL.query(
        Delivery.Repo, sql, [id])

    results = Enum.take_every(results, 2)

    context = %{ :user => get_session(conn, :user), :preview => true}
    Enum.map(results, fn r -> %{ status: true, id: Enum.at(r, 0), title: Enum.at(r, 1), raw: Enum.at(r, 2), element: HTML.to_html(context, Enum.at(r, 2))} end)
  end

  def links(conn, package) do
    results = query(conn, package.id, "link")
      |> Hyperlink.validate_links

    render(conn, "links.html", package: package, results: results)
  end

  def experiments(conn, %{"id" => id }) do
    package = Packages.get_package!(id)
    results = query(conn, package.id, "example")

    render(conn, "ab.html", package: package, results: results)
  end

  def images(conn, package) do
    results = query(conn, package.id, "image")

    render(conn, "images.html", package: package, results: results)
  end

  def element(conn, package, el) do
    results = query(conn, package.id, el)

    render(conn, "elements.html", package: package, results: results)
  end

  def index(conn, %{"id" => id }) do
    package = Packages.get_package!(id)
    render(conn, "index.html", package: package)
  end

  def check(conn, %{"id" => id, "check" => check }) do
    package = Packages.get_package!(id)

    case check do
      "links" -> links(conn, package)
      "images" -> images(conn, package)
      "tables" -> element(conn, package, "table")
      "code" -> element(conn, package, "code")
      _ -> render(conn, "index.html", package: package)
    end
  end

end
