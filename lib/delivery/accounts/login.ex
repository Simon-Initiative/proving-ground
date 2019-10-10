defmodule Delivery.Accounts.Login do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :user_id, :integer
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
