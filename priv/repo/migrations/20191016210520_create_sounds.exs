defmodule Delivery.Repo.Migrations.CreateSounds do
  use Ecto.Migration

  def change do
    create table(:sounds) do
      add :name, :string
      add :content, :binary

      timestamps()
    end

  end
end
