defmodule Delivery.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Delivery.Repo

  alias Delivery.Library.Snippet
  alias Delivery.Library.Sound

  @doc """
  Returns the list of snippets.

  ## Examples

      iex> list_snippets()
      [%Snippet{}, ...]

  """
  def list_snippets do
    Repo.all(Snippet)
  end

  def list_sounds do
    Repo.all(from u in Sound, select: %{name: u.name, id: u.id})
  end


  @doc """
  Gets a single snippet.

  Raises `Ecto.NoResultsError` if the Snippet does not exist.

  ## Examples

      iex> get_snippet!(123)
      %Snippet{}

      iex> get_snippet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_snippet!(id), do: Repo.get!(Snippet, id)

  def get_sound!(id), do: Repo.get!(Sound, id)

  @doc """
  Creates a snippet.

  ## Examples

      iex> create_snippet(%{field: value})
      {:ok, %Snippet{}}

      iex> create_snippet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_snippet(attrs \\ %{}) do
    %Snippet{}
    |> Snippet.changeset(attrs)
    |> Repo.insert()
  end

  def create_sound(attrs \\ %{}) do
    %Sound{}
    |> Sound.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a snippet.

  ## Examples

      iex> update_snippet(snippet, %{field: new_value})
      {:ok, %Snippet{}}

      iex> update_snippet(snippet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_snippet(%Snippet{} = snippet, attrs) do
    snippet
    |> Snippet.changeset(attrs)
    |> Repo.update()
  end

  def update_sound(%Sound{} = sound, attrs) do
    sound
    |> Sound.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Snippet.

  ## Examples

      iex> delete_snippet(snippet)
      {:ok, %Snippet{}}

      iex> delete_snippet(snippet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_snippet(%Snippet{} = snippet) do
    Repo.delete(snippet)
  end

  def delete_sound(%Sound{} = sound) do
    Repo.delete(sound)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking snippet changes.

  ## Examples

      iex> change_snippet(snippet)
      %Ecto.Changeset{source: %Snippet{}}

  """
  def change_snippet(%Snippet{} = snippet) do
    Snippet.changeset(snippet, %{})
  end

  def change_sound(%Sound{} = sound) do
    Sound.changeset(sound, %{})
  end
end
