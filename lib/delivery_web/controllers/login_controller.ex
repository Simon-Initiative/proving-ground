defmodule DeliveryWeb.LoginController do
  use DeliveryWeb, :controller
  alias Delivery.Activities
  alias Delivery.Accounts
  alias Delivery.Accounts.User

  @spec login(Plug.Conn.t(), map) :: Plug.Conn.t()
  def login(conn, %{"id" => id }) do

    user = Accounts.get_user!(id)

    conn
      |> put_session(:user, user)
      |> redirect(to: Routes.user_path(conn, :index))
  end

  def logout(conn, _params) do
    conn
      |> put_session(:user, nil)
      |> redirect(to: Routes.user_path(conn, :index))
  end

end
