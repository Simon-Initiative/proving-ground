defmodule Delivery.Objectives do
  import Ecto.Query, warn: false
  alias Delivery.Repo

  alias Delivery.Objectives.Objective

  def list_objectives do
    Repo.all(Objective)
  end

  def list_skills do
    Repo.all(Skill)
  end

  def list_objectives_for(package_id) do
    query = from o in Objective, where: o.package_id == ^package_id, order_by: o.description
    Repo.all(query)
  end

  def list_skills_for(package_id) do
    query = from a in Objective, where: a.package_id == ^package_id, order_by: a.id
    Repo.all(query)
  end

  def get_objective!(id), do: Repo.get!(Objective, id)

  def create_objective(attrs \\ %{}) do
    description = "She was an open book; he was illiterate."

    %Objective{description: description}
    |> Objective.changeset(attrs)
    |> Repo.insert()
  end

  def update_objective(%Objective{} = objective, attrs) do
    objective
    |> Objective.changeset(attrs)
    |> Repo.update()
  end

  def delete_objective(%Objective{} = objective) do
    Repo.delete(objective)
  end

  def change_objective(%Objective{} = objective) do
    Objective.changeset(objective, %{})
  end
end
