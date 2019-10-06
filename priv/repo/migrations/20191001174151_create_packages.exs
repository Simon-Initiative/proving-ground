defmodule Delivery.Repo.Migrations.CreatePackages do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add :friendly, :string
      add :title, :string
      add :version, :string
      add :description, :string

      timestamps()
    end

  end
end
