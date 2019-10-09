defmodule DeliveryWeb.SectionController do
  use DeliveryWeb, :controller

  alias Delivery.Packages
  alias Delivery.Sections
  alias Delivery.Sections.Section

  def index(conn, _params) do
    sections = Sections.list_sections()
    render(conn, "index.html", sections: sections)
  end

  def new(conn, _params) do
    changeset = Sections.change_section(%Section{})
    packages = Packages.list_packages()
    render(conn, "new.html", changeset: changeset, packages: packages)
  end

  def create(conn, %{"section" => section_params}) do
    case Sections.create_section(section_params) do
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
    render(conn, "show.html", section: section)
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
