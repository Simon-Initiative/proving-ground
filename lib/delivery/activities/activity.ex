defmodule Delivery.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:content, :draft_content]}
  @derive {Jason.Encoder, only: [:id, :friendly, :type, :title, :content, :timed, :require_completion]}
  schema "activities" do
    field :content, :map
    field :draft_content, :map
    field :draft_title, :string
    field :friendly, :string
    field :grading_strategy, :string
    field :require_completion, :boolean, default: false
    field :tags, {:array, :string}
    field :timed, :boolean, default: false
    field :title, :string
    field :type, :string
    field :is_draft, :boolean
    belongs_to :package, Delivery.Packages.Package, foreign_key: :package_id
    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:package_id, :is_draft, :friendly, :type, :timed, :require_completion, :grading_strategy, :tags, :title, :draft_title, :content, :draft_content])
    |> validate_required([:friendly, :timed, :require_completion, :title, :content])
  end

end
