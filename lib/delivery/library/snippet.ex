defmodule Delivery.Library.Snippet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "snippets" do
    field :content, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(snippet, attrs) do
    snippet
    |> cast(attrs, [:content, :name])
    |> validate_required([:content, :name])
  end
end
