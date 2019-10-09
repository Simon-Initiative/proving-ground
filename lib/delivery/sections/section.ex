defmodule Delivery.Sections.Section do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sections" do
    field :end_date, :date
    field :institution, :string
    field :start_date, :date
    field :title, :string
    belongs_to :package, Delivery.Packages.Package, foreign_key: :package_id
    has_many :entrollments, Delivery.Sections.Enrollment
    timestamps()
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:start_date, :end_date, :title, :institution, :package_id])
    |> validate_required([:start_date, :end_date, :title, :institution, :package_id])
  end
end
