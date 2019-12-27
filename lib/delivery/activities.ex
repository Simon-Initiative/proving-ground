defmodule Delivery.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Delivery.Repo

  alias Delivery.Activities.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(Activity)
  end

  def list_activities_for(package_id) do
    query = from a in Activity, where: a.package_id == ^package_id, order_by: a.id

    # Send the query to the repository
    Repo.all(query)
  end

  def get_draft_activities(package_id) do
    query =
      from e in Activity,
        where: e.package_id == ^package_id and e.is_draft == true,
        select: %{id: e.id, title: e.title}

    Repo.all(query)
  end

  def publish_all(package_id) do
    from(a in Activity,
      where: a.package_id == ^package_id,
      update: [set: [content: a.draft_content, is_draft: false]]
    )
    |> Repo.update_all([])
  end

  def publish(activity_id) do
    from(a in Activity,
      where: a.id == ^activity_id,
      update: [set: [content: a.draft_content, is_draft: false]]
    )
    |> Repo.update_all([])
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    content = %{
      "nodes" => [
        %{
          "object" => "block",
          "type" => "paragraph",
          "nodes" => [%{"object" => "text", "text" => "New Page"}]
        }
      ]
    }

    %Activity{content: content, draft_content: content}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{source: %Activity{}}

  """
  def change_activity(%Activity{} = activity) do
    Activity.changeset(activity, %{})
  end
end
