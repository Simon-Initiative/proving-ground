defmodule Delivery.Repo.Migrations.AddIsDraft do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :is_draft, :boolean
    end
  end
end
