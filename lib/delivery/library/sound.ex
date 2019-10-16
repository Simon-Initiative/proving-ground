defmodule Delivery.Library.Sound do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sounds" do
    field :content, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(sound, attrs) do
    sound
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
