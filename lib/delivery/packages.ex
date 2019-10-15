defmodule Delivery.Packages do
  @moduledoc """
  The Packages context.
  """

  import Ecto.Query, warn: false
  alias Delivery.Repo

  alias Delivery.Packages.Package

  @doc """
  Returns the list of packages.

  ## Examples

      iex> list_packages()
      [%Package{}, ...]

  """
  def list_packages do
    Repo.all(Package)
  end

  @doc """
  Gets a single package.

  Raises `Ecto.NoResultsError` if the Package does not exist.

  ## Examples

      iex> get_package!(123)
      %Package{}

      iex> get_package!(456)
      ** (Ecto.NoResultsError)

  """
  def get_package!(id), do: Repo.get!(Package, id)

  @doc """
  Creates a package.

  ## Examples

      iex> create_package(%{field: value})
      {:ok, %Package{}}

      iex> create_package(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_package(attrs \\ %{}) do
    %Package{}
    |> Package.changeset(attrs)
    |> Repo.insert()
  end


  def get_glossary_terms(id) do
    sql =
      """
      SELECT id, title, jsonb_path_query(content, '$.** ? (@.type == "definition")') FROM activities WHERE package_id = $1;
      """

    {:ok, %{rows: results }} = Ecto.Adapters.SQL.query(
        Delivery.Repo, sql, [id])

    results = Enum.map(results, fn r -> %{
      id: Enum.at(r, 0),
      title: Enum.at(r, 1),
      term: Enum.at(r, 2) |> Map.get("nodes") |> hd |> Map.get("text"),
      definition: Enum.at(r, 2) |> Map.get("data") |> Map.get("definition"),
      }
    end)

    mapped_results = Enum.reduce(results, %{}, fn e, m -> Map.put(m, Map.get(e, :term), e) end)

    Map.keys(mapped_results) |> Enum.map(fn e -> Map.get(mapped_results, e) end)
  end


  @doc """
  Updates a package.

  ## Examples

      iex> update_package(package, %{field: new_value})
      {:ok, %Package{}}

      iex> update_package(package, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_package(%Package{} = package, attrs) do
    package
    |> Package.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Package.

  ## Examples

      iex> delete_package(package)
      {:ok, %Package{}}

      iex> delete_package(package)
      {:error, %Ecto.Changeset{}}

  """
  def delete_package(%Package{} = package) do
    Repo.delete(package)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking package changes.

  ## Examples

      iex> change_package(package)
      %Ecto.Changeset{source: %Package{}}

  """
  def change_package(%Package{} = package) do
    Package.changeset(package, %{})
  end
end
