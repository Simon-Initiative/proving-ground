defmodule Delivery.LTI.Institution do
  use Ecto.Schema
  import Ecto.Changeset

  schema "institutions" do
    field :country_code, :string
    field :institution_email, :string
    field :institution_url, :string
    field :name, :string
    field :timezone, :string

    timestamps()
  end

  @doc false
  def changeset(institution, attrs) do
    institution
    |> cast(attrs, [:name, :country_code, :timezone, :institution_url, :institution_email])
    |> validate_required([:name, :country_code, :timezone, :institution_url, :institution_email])
  end
end
