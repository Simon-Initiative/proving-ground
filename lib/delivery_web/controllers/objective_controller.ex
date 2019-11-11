defmodule DeliveryWeb.ObjectiveController do
  use DeliveryWeb, :controller

  alias DeliveryWeb.Utils.HTML
  alias DeliveryWeb.Utils.Latex
  alias DeliveryWeb.Utils.Markdown
  alias DeliveryWeb.Utils.Text
  alias DeliveryWeb.Utils.XML

  alias Delivery.Objectives
  alias Delivery.Objectives.Objective

  def index(conn, %{"package_id" => package_id}) do
    objectives = Objectives.list_objectives_for(package_id)
    render(conn, "index.html", objectives: objectives, package_id: package_id)
  end

  def show(conn, %{"id" => id, "package_id" => package_id}) do
    o = Objectives.get_objective!(id)

    render(conn, "index.html", package_id: package_id, description: o.description)
  end

  def new(conn, %{"package_id" => package_id}) do
    changeset = Objectives.change_objective(%Objective{package_id: package_id})
    render(conn, "new.html", changeset: changeset, package_id: package_id)
  end

  def create(conn, %{"objective" => objective_params}) do
    case Objectives.create_objective(objective_params) do
      {:ok, objective} ->
        conn
        |> put_flash(:info, "Page created successfully.")
        |> redirect(to: Routes.page_path(conn, :show, objective_params["package_id"], objective))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, package_id: objective_params["package_id"])
    end
  end

  def edit(conn, %{"id" => id, "package_id" => package_id}) do
    objective = Objectives.get_objective!(id)
    changeset = Objectives.change_objective(objective)
    render(conn, "edit.html", objective: objective, changeset: changeset, package_id: package_id)
  end

  def update(conn, %{"id" => id, "package_id" => package_id, "objective" => objective_params}) do
    objective = Objectives.get_objective!(id)

    case Objectives.update_objective(objective, objective_params) do
      {:ok, objective} ->
        conn
        |> put_flash(:info, "Objective updated successfully.")

      # |> redirect(to: Routes.objective_path(conn, :show, package_id, objective))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          objective: objective,
          changeset: changeset,
          package_id: package_id
        )
    end
  end

  def delete(conn, %{"id" => id, "package_id" => package_id}) do
    objective = Objectives.get_objective!(id)
    {:ok, _objective} = Objectives.delete_objective(objective)

    conn
    |> put_flash(:info, "Objective deleted successfully.")
    |> redirect(to: Routes.package_path(conn, :show, package_id))
  end
end
