defmodule DeliveryWeb.Router do
  use DeliveryWeb, :router

  defp fetch_user_token(conn, _) do
    conn
    |> assign(:current_user, get_session(conn, :user))
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DeliveryWeb do
    pipe_through :browser

    get "/", RootController, :index


    get "/packages", PackageController, :index
    get "/packages/:id/show", PackageController, :show
    get "/packages/:id/delete", PackageController, :delete

    live "/packages/new", PackageLive.New
    live "/packages/:id/edit", PackageLive.Edit

    resources "/packages/:package_id/activities", ActivityController
    get "/page/:id", PageController, :show

    resources "/users", UserController
    get "/login/:id", LoginController, :login
    get "/logout", LoginController, :logout

    live "/search", SearchLive
  end

  scope "/api", DeliveryWeb do
    pipe_through :api

    post "/page/:id", PageController, :write
    get "/question/:id", QuestionController, :read
    post "/question/:id", QuestionController, :write

  end
end
