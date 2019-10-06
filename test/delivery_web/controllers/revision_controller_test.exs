defmodule DeliveryWeb.RevisionControllerTest do
  use DeliveryWeb.ConnCase

  alias Delivery.Pages

  @create_attrs %{content: %{}, graded: true, page_id: 42, requires_completion: true, revision_type: "some revision_type", timed: true, title: "some title", type: "some type"}
  @update_attrs %{content: %{}, graded: false, page_id: 43, requires_completion: false, revision_type: "some updated revision_type", timed: false, title: "some updated title", type: "some updated type"}
  @invalid_attrs %{content: nil, graded: nil, page_id: nil, requires_completion: nil, revision_type: nil, timed: nil, title: nil, type: nil}

  def fixture(:revision) do
    {:ok, revision} = Pages.create_revision(@create_attrs)
    revision
  end

  describe "index" do
    test "lists all revision", %{conn: conn} do
      conn = get(conn, Routes.revision_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Revision"
    end
  end

  describe "new revision" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.revision_path(conn, :new))
      assert html_response(conn, 200) =~ "New Revision"
    end
  end

  describe "create revision" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.revision_path(conn, :create), revision: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.revision_path(conn, :show, id)

      conn = get(conn, Routes.revision_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Revision"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.revision_path(conn, :create), revision: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Revision"
    end
  end

  describe "edit revision" do
    setup [:create_revision]

    test "renders form for editing chosen revision", %{conn: conn, revision: revision} do
      conn = get(conn, Routes.revision_path(conn, :edit, revision))
      assert html_response(conn, 200) =~ "Edit Revision"
    end
  end

  describe "update revision" do
    setup [:create_revision]

    test "redirects when data is valid", %{conn: conn, revision: revision} do
      conn = put(conn, Routes.revision_path(conn, :update, revision), revision: @update_attrs)
      assert redirected_to(conn) == Routes.revision_path(conn, :show, revision)

      conn = get(conn, Routes.revision_path(conn, :show, revision))
      assert html_response(conn, 200) =~ "some updated revision_type"
    end

    test "renders errors when data is invalid", %{conn: conn, revision: revision} do
      conn = put(conn, Routes.revision_path(conn, :update, revision), revision: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Revision"
    end
  end

  describe "delete revision" do
    setup [:create_revision]

    test "deletes chosen revision", %{conn: conn, revision: revision} do
      conn = delete(conn, Routes.revision_path(conn, :delete, revision))
      assert redirected_to(conn) == Routes.revision_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.revision_path(conn, :show, revision))
      end
    end
  end

  defp create_revision(_) do
    revision = fixture(:revision)
    {:ok, revision: revision}
  end
end
