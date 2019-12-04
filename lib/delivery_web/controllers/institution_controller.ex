defmodule DeliveryWeb.InstitutionController do
  use DeliveryWeb, :controller

  alias Delivery.LTI
  alias Delivery.LTI.Institution

  def index(conn, _params) do
    institutions = LTI.list_institutions()
    render(conn, "index.html", institutions: institutions)
  end

  def new(conn, _params) do
    changeset = LTI.change_institution(%Institution{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"institution" => institution_params}) do
    case LTI.create_institution(institution_params) do
      {:ok, institution} ->
        conn
        |> put_flash(:info, "Institution created successfully.")
        |> redirect(to: Routes.institution_path(conn, :show, institution))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    institution = LTI.get_institution!(id)
    render(conn, "show.html", institution: institution)
  end

  def edit(conn, %{"id" => id}) do
    institution = LTI.get_institution!(id)
    changeset = LTI.change_institution(institution)
    render(conn, "edit.html", institution: institution, changeset: changeset)
  end

  def update(conn, %{"id" => id, "institution" => institution_params}) do
    institution = LTI.get_institution!(id)

    case LTI.update_institution(institution, institution_params) do
      {:ok, institution} ->
        conn
        |> put_flash(:info, "Institution updated successfully.")
        |> redirect(to: Routes.institution_path(conn, :show, institution))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", institution: institution, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    institution = LTI.get_institution!(id)
    {:ok, _institution} = LTI.delete_institution(institution)

    conn
    |> put_flash(:info, "Institution deleted successfully.")
    |> redirect(to: Routes.institution_path(conn, :index))
  end
end
