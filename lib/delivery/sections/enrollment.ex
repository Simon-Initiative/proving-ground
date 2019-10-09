defmodule Delivery.Sections.Enrollment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "enrollments" do
    field :role, :string
    belongs_to :section, Delivery.Sections.Section, foreign_key: :section_id
    belongs_to :user, Delivery.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, [:user_id, :section_id, :role])
    |> validate_required([:user_id, :section_id, :role])
  end
end
