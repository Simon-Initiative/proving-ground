defmodule Delivery.Objectives.ObjectiveSkill do
  use Ecto.Schema
  import Ecto.Changeset

  # Join table for objectives, skills
  schema "objective_skills" do
    belongs_to :objectives, Delivery.Objectives.Objective, foreign_key: :objective_id
    belongs_to :skills, Delivery.Objectives.Skill, foreign_key: :skill_id
    timestamps()
  end

  @doc false
  def changeset(objective_skill, attrs) do
    objective_skill
    |> cast(attrs, [:objective_id, :skill_id])
    |> validate_required([:objective_id, :skill_id])
  end
end
