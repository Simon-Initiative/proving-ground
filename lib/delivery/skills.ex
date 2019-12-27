defmodule Delivery.Skills do
  import Ecto.Query, warn: false
  alias Delivery.Repo
  import Logger

  alias Delivery.Objectives.{Objective, Skill}
  alias Delivery.Objectives
  alias Delivery.Objectives.ObjectiveSkill
  alias DeliveryWeb.Utils.OneLiners

  def create_skill(attrs \\ %{}) do
    objective =
      Objectives.get_objective!(attrs["objective"])
      |> Repo.preload(:skills)

    %Skill{
      description: Map.get(attrs, :description, hd(Enum.take_random(OneLiners.skills(), 1)))
    }
    |> Repo.preload(:objectives)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:objectives, [objective])
    |> Repo.insert()
  end

  def list_skills do
    Repo.all(Skill)
  end

  def list_skills_for(package_id) do
    query = from a in Objective, where: a.package_id == ^package_id, order_by: a.id
    Repo.all(query)
  end

  def get_skill!(id), do: Repo.get!(Skill, id)

  def detach_from(objective_id, skill_id) do
    "objective_skill"
    |> where(objective_id: ^objective_id)
    |> where(skill_id: ^skill_id)
    |> Repo.delete()
  end

  def delete_skill(%Skill{} = skill) do
    Repo.delete(skill)
  end
end
