defmodule DeliveryWeb.SectionController do
  use DeliveryWeb, :controller

  alias Delivery.Packages
  alias Delivery.Sections
  alias Delivery.Sections.Section
  alias Delivery.Sections.Enrollment
  alias Delivery.Accounts


  def index(conn, _params) do
    user = get_session(conn, :user)
    sections = Sections.list_sections_for_user(user.id)
    render(conn, "index.html", sections: sections)
  end

  def remove_enrollment(conn, %{"id" => id, "section_id" => section_id } ) do

    Sections.remove_enrollment(id)

    conn
    |> put_flash(:info, "Enrollment deleted successfully.")
    |> redirect(to: Routes.section_path(conn, :show, section_id))
  end

  def add_enrollment(conn, %{"section_id" => section_id, "user_id" => user_id, "role" => role } ) do
    Sections.add_enrollment(section_id, user_id, role)

    conn
    |> put_flash(:info, "Enrollment added successfully.")
    |> redirect(to: Routes.section_path(conn, :show, section_id))
  end


  def new(conn, _params) do
    changeset = Sections.change_section(%Section{})
    packages = Packages.list_packages()
    render(conn, "new.html", changeset: changeset, packages: packages)
  end

  def create(conn, %{"section" => section_params}) do

    user = get_session(conn, :user)
    with_owner = Map.put(section_params, "enrollments", [%{ "user_id" => user.id, "role" => "owner"}])

    case Sections.create_section(with_owner) do
      {:ok, section} ->
        conn
          |> put_flash(:info, "Section created successfully.")
          |> redirect(to: Routes.section_path(conn, :show, section))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, packages: Packages.list_packages())
    end
  end

  def show(conn, %{"id" => id}) do
    section = Sections.get_section!(id)
    enrollments = Sections.get_enrollments_for(section.id)

    enrolled = Enum.reduce(enrollments, %{}, fn e, m -> Map.put(m, e.email, e.email) end)

    users = Accounts.list_users()
      |> Enum.filter(fn u -> !Map.has_key?(enrolled, u.email) end)

    changeset = Enrollment.changeset(%Enrollment{}, %{})

    render(conn, "show.html", section: section, enrollments: enrollments, users: users, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    section = Sections.get_section!(id)
    changeset = Sections.change_section(section)
    packages = Packages.list_packages()
    render(conn, "edit.html", section: section, changeset: changeset, packages: packages)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Sections.get_section!(id)

    case Sections.update_section(section, section_params) do
      {:ok, section} ->
        conn
        |> put_flash(:info, "Section updated successfully.")
        |> redirect(to: Routes.section_path(conn, :show, section))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", section: section, changeset: changeset, packages: Packages.list_packages())
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Sections.get_section!(id)
    {:ok, _section} = Sections.delete_section(section)

    conn
    |> put_flash(:info, "Section deleted successfully.")
    |> redirect(to: Routes.section_path(conn, :index))
  end
end
