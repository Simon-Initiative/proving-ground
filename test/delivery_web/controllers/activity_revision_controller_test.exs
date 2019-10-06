defmodule DeliveryWeb.ActivityRevisionControllerTest do
  use DeliveryWeb.ConnCase

  alias Delivery.Activities

  @create_attrs %{activity_id: 42, content: %{}, purpose: "some purpose", revision_type: "some revision_type", title: "some title", type: "some type"}
  @update_attrs %{activity_id: 43, content: %{}, purpose: "some updated purpose", revision_type: "some updated revision_type", title: "some updated title", type: "some updated type"}
  @invalid_attrs %{activity_id: nil, content: nil, purpose: nil, revision_type: nil, title: nil, type: nil}

  def fixture(:activity_revision) do
    {:ok, activity_revision} = Activities.create_activity_revision(@create_attrs)
    activity_revision
  end

  describe "index" do
    test "lists all revision", %{conn: conn} do
      conn = get(conn, Routes.activity_revision_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Revision"
    end
  end

  describe "new activity_revision" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.activity_revision_path(conn, :new))
      assert html_response(conn, 200) =~ "New Activity revision"
    end
  end

  describe "create activity_revision" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.activity_revision_path(conn, :create), activity_revision: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.activity_revision_path(conn, :show, id)

      conn = get(conn, Routes.activity_revision_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Activity revision"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.activity_revision_path(conn, :create), activity_revision: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Activity revision"
    end
  end

  describe "edit activity_revision" do
    setup [:create_activity_revision]

    test "renders form for editing chosen activity_revision", %{conn: conn, activity_revision: activity_revision} do
      conn = get(conn, Routes.activity_revision_path(conn, :edit, activity_revision))
      assert html_response(conn, 200) =~ "Edit Activity revision"
    end
  end

  describe "update activity_revision" do
    setup [:create_activity_revision]

    test "redirects when data is valid", %{conn: conn, activity_revision: activity_revision} do
      conn = put(conn, Routes.activity_revision_path(conn, :update, activity_revision), activity_revision: @update_attrs)
      assert redirected_to(conn) == Routes.activity_revision_path(conn, :show, activity_revision)

      conn = get(conn, Routes.activity_revision_path(conn, :show, activity_revision))
      assert html_response(conn, 200) =~ "some updated purpose"
    end

    test "renders errors when data is invalid", %{conn: conn, activity_revision: activity_revision} do
      conn = put(conn, Routes.activity_revision_path(conn, :update, activity_revision), activity_revision: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Activity revision"
    end
  end

  describe "delete activity_revision" do
    setup [:create_activity_revision]

    test "deletes chosen activity_revision", %{conn: conn, activity_revision: activity_revision} do
      conn = delete(conn, Routes.activity_revision_path(conn, :delete, activity_revision))
      assert redirected_to(conn) == Routes.activity_revision_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.activity_revision_path(conn, :show, activity_revision))
      end
    end
  end

  defp create_activity_revision(_) do
    activity_revision = fixture(:activity_revision)
    {:ok, activity_revision: activity_revision}
  end
end
