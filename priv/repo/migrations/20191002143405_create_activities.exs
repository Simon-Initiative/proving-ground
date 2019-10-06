defmodule Delivery.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :friendly, :string
      add :package_id, :id
      add :type, :string
      add :timed, :boolean, default: false, null: false
      add :require_completion, :boolean, default: false, null: false
      add :grading_strategy, :string
      add :tags, {:array, :string}
      add :title, :string
      add :draft_title, :string
      add :content, :map
      add :draft_content, :map

      timestamps()
    end

  end
end
