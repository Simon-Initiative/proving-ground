defmodule Delivery.Objectives.Objective do
  use Ecto.Schema
  import Ecto.Changeset
  alias Delivery.Objectives.Objective

  schema "objectives" do
    field :description, :string
    belongs_to :package, Delivery.Packages.Package, foreign_key: :package_id

    many_to_many :skills, Delivery.Objectives.Skill,
      join_through: Delivery.Objectives.ObjectiveSkill

    timestamps()
  end

  @doc false
  def changeset(%Objective{} = objective, attrs \\ %{}) do
    objective
    |> cast(attrs, [:description, :package_id])
    |> validate_required([:description, :package_id])
  end
end
