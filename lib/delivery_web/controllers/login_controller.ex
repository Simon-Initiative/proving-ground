defmodule DeliveryWeb.LoginController do
  use DeliveryWeb, :controller

  alias Delivery.Accounts
  alias Delivery.Accounts.Login

  def show(conn, _params) do
    changeset = Login.changeset(%Login{}, %{})
    render(conn, "index.html", changeset: changeset, users: Accounts.list_users())
  end

  def login(conn, %{"user_id" => id }) do

    user = Accounts.get_user!(id)

    conn
      |> put_session(:user, user)
      |> redirect(to: Routes.section_path(conn, :index))
  end

  def logout(conn, _params) do
    conn
      |> put_session(:user, nil)
      |> redirect(to: Routes.login_path(conn, :show))
  end

end
