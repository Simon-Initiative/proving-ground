defmodule Delivery.Repo.Migrations.Sound do
  use Ecto.Migration

  def change do
    alter table(:sounds) do
      modify :content, :string
    end
  end
end
