defmodule Delivery.Objectives.Objective do
  use Ecto.Schema
  import Ecto.Changeset

  schema "objectives" do
    field :description, :string
    belongs_to :package, Delivery.Packages.Package, foreign_key: :package_id
    many_to_many :skills, Delivery.Objectives.Skill, join_through: "objective_skill"

    timestamps()
  end

  @doc false
  def changeset(objective, attrs) do
    objective
    |> cast(attrs, [:description, :package_id])
    |> validate_required([:description, :package_id])
  end
end
