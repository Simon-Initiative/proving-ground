defmodule DeliveryWeb.SnippetController do
  use DeliveryWeb, :controller

  alias Delivery.Library
  alias Delivery.Library.Snippet

  def index(conn, _params) do
    snippets = Library.list_snippets()
    render(conn, "index.html", snippets: snippets)
  end

  def new(conn, _params) do
    changeset = Library.change_snippet(%Snippet{})
    render(conn, "new.html", changeset: changeset)
  end

  def read_all(conn, _params) do
    json(conn, Library.list_snippets())
  end

  def write(conn, %{ "snippet" => params}) do
    case Library.create_snippet(params) do
      {:ok, snippet} ->
        conn
        |> json(snippet)

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> json(%{ "status" => "failed"})
    end

  end

  def create(conn, %{"snippet" => snippet_params}) do
    case Library.create_snippet(snippet_params) do
      {:ok, snippet} ->
        conn
        |> put_flash(:info, "Snippet created successfully.")
        |> redirect(to: Routes.snippet_path(conn, :show, snippet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    snippet = Library.get_snippet!(id)
    content = DeliveryWeb.Utils.HTML.to_html(Map.get(snippet.content, "nodes") |> Map.get("nodes"))

    render(conn, "show.html", snippet: snippet, content: content)
  end

  def edit(conn, %{"id" => id}) do
    snippet = Library.get_snippet!(id)
    changeset = Library.change_snippet(snippet)
    render(conn, "edit.html", snippet: snippet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "snippet" => snippet_params}) do
    snippet = Library.get_snippet!(id)

    case Library.update_snippet(snippet, snippet_params) do
      {:ok, snippet} ->
        conn
        |> put_flash(:info, "Snippet updated successfully.")
        |> redirect(to: Routes.snippet_path(conn, :show, snippet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", snippet: snippet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    snippet = Library.get_snippet!(id)
    {:ok, _snippet} = Library.delete_snippet(snippet)

    conn
    |> put_flash(:info, "Snippet deleted successfully.")
    |> redirect(to: Routes.snippet_path(conn, :index))
  end
end
