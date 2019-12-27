defmodule Delivery.Objectives.ActivityObjective do
  use Ecto.Schema
  import Ecto.Changeset

  # Join table for activities, objectives
  schema "activity_objective" do
    belongs_to :activities, Delivery.Activities.Activity, foreign_key: :activity_id
    belongs_to :objectives, Delivery.Objectives.Objective, foreign_key: :objective_id

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:activity_id, :objective_id])
    |> validate_required([:activity_id, :objective_id])
  end
end
