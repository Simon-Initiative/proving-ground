defmodule Delivery.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :start_date, :date
      add :end_date, :date
      add :title, :string
      add :institution, :string
      add(:package_id, references(:packages))

      timestamps()
    end

  end
end
