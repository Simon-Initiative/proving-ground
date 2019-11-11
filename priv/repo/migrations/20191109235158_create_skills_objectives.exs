defmodule Delivery.Repo.Migrations.CreateSkillsObjectives do
  use Ecto.Migration

  # Activity  ∍ - ∊ Objective
  # Objective ∍ - ∊ Skill
  # Objective ∍ - ⊢ Package

  # Two join tables -> objective_skills, activity_objectives
  def change do
    create table(:skills) do
      add :description, :string
      timestamps()
    end

    create table(:objectives) do
      add :description, :string
      add :package_id, references(:packages, on_delete: :delete_all)
      timestamps()
    end

    create table(:objective_skills) do
      add :objective_id, references(:objectives, on_delete: :restrict)
      add :skill_id, references(:skills, on_delete: :restrict)
      timestamps()
    end

    create table(:activity_objectives) do
      add :activity_id, references(:activities, on_delete: :delete_all)
      add :objective_id, references(:objectives, on_delete: :delete_all)
      timestamps()
    end
  end
end
