defmodule DeliveryWeb.SkillController do
  use DeliveryWeb, :controller

  alias Delivery.Skills
  alias Delivery.Objectives.Skill
  alias Delivery.Repo

  require Logger

  def create(%Plug.Conn{} = conn, skill_params) do
    package_id = skill_params["package_id"]

    case Skills.create_skill(skill_params) do
      {:ok, _skill} ->
        conn
        |> put_flash(:info, "Skill created successfully.")
        |> redirect(to: Routes.package_path(conn, :show, package_id))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Skill creation failed.")
    end
  end

  # def update(conn, %{"id" => id, "package_id" => package_id, "objective" => objective_params}) do
  #   objective = Skills.get_objective!(id)

  #   case Skills.update_objective(objective, objective_params) do
  #     {:ok, objective} ->
  #       conn
  #       |> put_flash(:info, "Skill updated successfully.")

  #     # |> redirect(to: Routes.objective_path(conn, :show, package_id, objective))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html",
  #         objective: objective,
  #         changeset: changeset,
  #         package_id: package_id
  #       )
  #   end
  # end

  def delete(conn, %{"id" => id, "package_id" => package_id, "objective" => objective_id}) do
    skill =
      Skills.get_skill!(id)
      |> Repo.preload(:objectives)

    case length(skill.objectives) do
      1 ->
        {:ok, _skill} = Skills.delete_skill(skill)
        redirect_after_delete(conn, package_id)

      _ ->
        Skills.detach_from(objective_id, skill.id)
        redirect_after_delete(conn, package_id)
    end
  end

  def redirect_after_delete(conn, package_id) do
    conn
    |> put_flash(:info, "Skill deleted successfully.")
    |> redirect(to: Routes.package_path(conn, :show, package_id))
  end
end
