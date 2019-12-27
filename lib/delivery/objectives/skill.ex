defmodule Delivery.Objectives.Skill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skills" do
    field :description, :string

    many_to_many :objectives, Delivery.Objectives.Objective,
      join_through: Delivery.Objectives.ObjectiveSkill

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:description, :objectives])
    |> validate_required([:description])
  end
end
