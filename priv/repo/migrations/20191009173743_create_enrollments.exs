defmodule Delivery.Repo.Migrations.CreateEnrollments do
  use Ecto.Migration

  def change do
    create table(:enrollments) do
      add :user_id, references(:users)
      add :section_id, references(:sections)
      add :role, :string

      timestamps()
    end

  end
end
