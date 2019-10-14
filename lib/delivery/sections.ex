defmodule Delivery.Sections do
  @moduledoc """
  The Sections context.
  """

  import Ecto.Query, warn: false
  alias Delivery.Repo
  alias Delivery.Activities.Activity
  alias Delivery.Sections.Section
  alias Delivery.Packages.Package
  alias Delivery.Sections.Enrollment
  alias Delivery.Accounts.User


  @doc """
  Returns the list of sections.

  ## Examples

      iex> list_sections()
      [%Section{}, ...]

  """
  def list_sections do
    Repo.all(Section)
  end

  def list_sections_for_user(user_id) do
    query = from s in Section,
          join: e in Enrollment, on: s.id == e.section_id,
          join: u in User, on: u.id == e.user_id,
          where: u.id == ^user_id,
          select:  %{role: e.role, title: s.title, id: s.id }
    Repo.all(query)
  end

  def get_pages_for_course(section_id) do
    query = from a in Activity,
          join: p in Package, on: a.package_id == p.id,
          join: s in Section, on: s.package_id == p.id,
          where: s.id == ^section_id,
          order_by: a.id,
          select:  %{page_id: a.id, title: a.title }
    Repo.all(query)
  end

  def add_enrollment(section_id, user_id, role) do
    %Enrollment{}
    |> Enrollment.changeset(%{ section_id: section_id, user_id: user_id, role: role })
    |> Repo.insert()
  end

  def remove_enrollment(id) do
    e = Repo.get!(Enrollment, id)
    Repo.delete!(e)
  end

  @doc """
  Gets a single section.

  Raises `Ecto.NoResultsError` if the Section does not exist.

  ## Examples

      iex> get_section!(123)
      %Section{}

      iex> get_section!(456)
      ** (Ecto.NoResultsError)

  """
  def get_section!(id) do

    Repo.get!(Section, id)

  end

  def get_enrollments_for(section_id) do

    query = from e in Enrollment,
          join: u in User, on: u.id == e.user_id,
          where: e.section_id == ^section_id,
          select:  %{id: e.id, role: e.role, email: u.email, first_name: u.first_name, last_name: u.last_name}
    Repo.all(query)
  end

  @doc """
  Creates a section.

  ## Examples

      iex> create_section(%{field: value})
      {:ok, %Section{}}

      iex> create_section(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_section(attrs \\ %{}) do

    owner = hd(Map.get(attrs, "enrollments"))

    result = %Section{}
      |> Section.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, section} ->
        create_enrollment(Map.put(owner, "section_id", section.id))
      _ -> nil
    end

    result
  end

  @spec create_enrollment(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def create_enrollment(attrs \\ %{}) do
    %Enrollment{}
    |> Enrollment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a section.

  ## Examples

      iex> update_section(section, %{field: new_value})
      {:ok, %Section{}}

      iex> update_section(section, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_section(%Section{} = section, attrs) do
    section
    |> Section.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Section.

  ## Examples

      iex> delete_section(section)
      {:ok, %Section{}}

      iex> delete_section(section)
      {:error, %Ecto.Changeset{}}

  """
  def delete_section(%Section{} = section) do
    Repo.transaction(fn ->
      Ecto.Adapters.SQL.query(
         Delivery.Repo, "DELETE FROM enrollments WHERE section_id = $1", [section.id])
      Repo.delete(section)
    end)

  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking section changes.

  ## Examples

      iex> change_section(section)
      %Ecto.Changeset{source: %Section{}}

  """
  def change_section(%Section{} = section) do
    Section.changeset(section, %{})
  end
end
