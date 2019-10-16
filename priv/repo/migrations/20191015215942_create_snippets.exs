defmodule Delivery.Repo.Migrations.CreateSnippets do
  use Ecto.Migration

  def change do
    create table(:snippets) do
      add :content, :map
      add :name, :string

      timestamps()
    end

  end
end
