defmodule Delivery.Objectives.Skill do
  use Ecto.Schema
  import Ecto.Changeset
  alias Delivery.Objectives.Skill

  schema "skills" do
    field :description, :string

    many_to_many :objectives, Delivery.Objectives.Objective,
      join_through: Delivery.Objectives.ObjectiveSkill

    timestamps()
  end

  @doc false
  def changeset(%Skill{} = skill, attrs \\ %{}) do
    skill
    |> cast(attrs, [:description])
    |> cast_assoc(:objectives)
    |> validate_required([:description])
  end
end
