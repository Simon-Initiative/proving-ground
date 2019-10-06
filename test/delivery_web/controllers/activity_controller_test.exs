defmodule DeliveryWeb.ActivityControllerTest do
  use DeliveryWeb.ConnCase

  alias Delivery.Activities

  @create_attrs %{content: %{}, draft_content: %{}, draft_title: "some draft_title", friendly: "some friendly", grading_strategy: "some grading_strategy", require_completion: true, tags: [], timed: true, title: "some title", type: "some type"}
  @update_attrs %{content: %{}, draft_content: %{}, draft_title: "some updated draft_title", friendly: "some updated friendly", grading_strategy: "some updated grading_strategy", require_completion: false, tags: [], timed: false, title: "some updated title", type: "some updated type"}
  @invalid_attrs %{content: nil, draft_content: nil, draft_title: nil, friendly: nil, grading_strategy: nil, require_completion: nil, tags: nil, timed: nil, title: nil, type: nil}

  def fixture(:activity) do
    {:ok, activity} = Activities.create_activity(@create_attrs)
    activity
  end

  describe "index" do
    test "lists all activities", %{conn: conn} do
      conn = get(conn, Routes.activity_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Activities"
    end
  end

  describe "new activity" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.activity_path(conn, :new))
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "create activity" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.activity_path(conn, :create), activity: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.activity_path(conn, :show, id)

      conn = get(conn, Routes.activity_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Activity"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.activity_path(conn, :create), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "edit activity" do
    setup [:create_activity]

    test "renders form for editing chosen activity", %{conn: conn, activity: activity} do
      conn = get(conn, Routes.activity_path(conn, :edit, activity))
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "update activity" do
    setup [:create_activity]

    test "redirects when data is valid", %{conn: conn, activity: activity} do
      conn = put(conn, Routes.activity_path(conn, :update, activity), activity: @update_attrs)
      assert redirected_to(conn) == Routes.activity_path(conn, :show, activity)

      conn = get(conn, Routes.activity_path(conn, :show, activity))
      assert html_response(conn, 200) =~ "some updated draft_title"
    end

    test "renders errors when data is invalid", %{conn: conn, activity: activity} do
      conn = put(conn, Routes.activity_path(conn, :update, activity), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "delete activity" do
    setup [:create_activity]

    test "deletes chosen activity", %{conn: conn, activity: activity} do
      conn = delete(conn, Routes.activity_path(conn, :delete, activity))
      assert redirected_to(conn) == Routes.activity_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.activity_path(conn, :show, activity))
      end
    end
  end

  defp create_activity(_) do
    activity = fixture(:activity)
    {:ok, activity: activity}
  end
end
