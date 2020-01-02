defmodule DeliveryWeb.ObjectiveController do
  use DeliveryWeb, :controller

  alias Delivery.Objectives

  def create(%Plug.Conn{} = conn, objective_params) do
    package_id = objective_params["package_id"]

    case Objectives.create_objective(objective_params) do
      {:ok, _objective} ->
        conn
        |> put_flash(:info, "Objective created successfully.")
        |> redirect(to: Routes.package_path(conn, :show, package_id))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Objective creation failed.")
    end
  end

  def edit(conn, %{"id" => id, "package_id" => package_id}) do
    objective = Objectives.get_objective!(id)
    changeset = Objectives.change_objective(objective)
    render(conn, "edit.html", objective: objective, changeset: changeset, package_id: package_id)
  end

  def update(conn, %{"id" => id, "package_id" => package_id, "objective" => objective_params}) do
    IO.inspect(objective_params)
    objective = Objectives.get_objective!(id)

    case Objectives.update_objective(objective, objective_params) do
      {:ok, _objective} ->
        conn
        |> put_flash(:info, "Objective updated successfully.")
        |> redirect(to: Routes.package_path(conn, :show, package_id))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:danger, "Objective failed to be updated.")
        |> redirect(to: Routes.package_path(conn, :show, package_id))
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
