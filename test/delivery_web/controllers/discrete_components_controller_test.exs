defmodule DeliveryWeb.DiscreteComponentsControllerTest do
  use DeliveryWeb.ConnCase

  alias Delivery.Examples

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:discrete_components) do
    {:ok, discrete_components} = Examples.create_discrete_components(@create_attrs)
    discrete_components
  end

  describe "index" do
    test "lists all discrete_components", %{conn: conn} do
      conn = get(conn, Routes.discrete_components_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Discrete components"
    end
  end

  describe "new discrete_components" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.discrete_components_path(conn, :new))
      assert html_response(conn, 200) =~ "New Discrete components"
    end
  end

  describe "create discrete_components" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.discrete_components_path(conn, :create), discrete_components: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.discrete_components_path(conn, :show, id)

      conn = get(conn, Routes.discrete_components_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Discrete components"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.discrete_components_path(conn, :create), discrete_components: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Discrete components"
    end
  end

  describe "edit discrete_components" do
    setup [:create_discrete_components]

    test "renders form for editing chosen discrete_components", %{conn: conn, discrete_components: discrete_components} do
      conn = get(conn, Routes.discrete_components_path(conn, :edit, discrete_components))
      assert html_response(conn, 200) =~ "Edit Discrete components"
    end
  end

  describe "update discrete_components" do
    setup [:create_discrete_components]

    test "redirects when data is valid", %{conn: conn, discrete_components: discrete_components} do
      conn = put(conn, Routes.discrete_components_path(conn, :update, discrete_components), discrete_components: @update_attrs)
      assert redirected_to(conn) == Routes.discrete_components_path(conn, :show, discrete_components)

      conn = get(conn, Routes.discrete_components_path(conn, :show, discrete_components))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, discrete_components: discrete_components} do
      conn = put(conn, Routes.discrete_components_path(conn, :update, discrete_components), discrete_components: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Discrete components"
    end
  end

  describe "delete discrete_components" do
    setup [:create_discrete_components]

    test "deletes chosen discrete_components", %{conn: conn, discrete_components: discrete_components} do
      conn = delete(conn, Routes.discrete_components_path(conn, :delete, discrete_components))
      assert redirected_to(conn) == Routes.discrete_components_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.discrete_components_path(conn, :show, discrete_components))
      end
    end
  end

  defp create_discrete_components(_) do
    discrete_components = fixture(:discrete_components)
    {:ok, discrete_components: discrete_components}
  end
end
