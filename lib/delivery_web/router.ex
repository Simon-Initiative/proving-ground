defmodule DeliveryWeb.Router do
  use DeliveryWeb, :router

  alias DeliveryWeb.Router.Helpers, as: Routes

  defp fetch_user_token(conn, _) do
    conn
      |> assign(:current_user, get_session(conn, :user))
  end

  defp redirect_to_login(conn, _) do
    case get_session(conn, :user) do
      nil -> redirect(conn, to: Routes.login_path(conn, :show))
      _ -> conn
    end
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

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user_token
    plug :redirect_to_login
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DeliveryWeb do
    pipe_through :browser


    get "/login", LoginController, :show
    post "/login", LoginController, :login
    get "/users/new", UserController, :new
    post "/users", UserController, :create

    get "/discrete_components", DiscreteComponentsController, :index

  end

  scope "/", DeliveryWeb do
    pipe_through :protected

    get "/", RootController, :index
    get "/packages", PackageController, :index
    get "/packages/:id/show", PackageController, :show
    get "/packages/:id/delete", PackageController, :delete

    live "/packages/new", PackageLive.New
    live "/packages/:id/edit", PackageLive.Edit

    resources "/snippets", SnippetController

    get "/qa/:id", QAController, :index
    get "/qa/:id/:check", QAController, :check
    get "/experiments/:id", QAController, :experiments

    resources "/sections", SectionController
    post "/sections/:section_id/enrollment", SectionController, :add_enrollment
    delete "/sections/:section_id/enrollment/:id", SectionController, :remove_enrollment

    resources "/packages/:package_id/activities", ActivityController, except: [:edit]
    get "/packages/:package_id/activities/publish/all", ActivityController, :publish_all
    get "/packages/:package_id/activities/:activity_id/publish", ActivityController, :publish

    get "/course/:section_id", CourseController, :index
    get "/course/:section_id/glossary", CourseController, :glossary
    get "/course/:section_id/:page_id", CourseController, :page


    get "/packages/:package_id/activities/:id/edit", PageController, :show

    get "/users", UserController, :index
    get "/users/:id/edit", UserController, :edit
    get "/users/:id", UserController, :show
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    get "/logout", LoginController, :logout

    get "/sound", SoundController, :index
    get "/sound/:id", SoundController, :loaded


    live "/search", SearchLive
    live "/notification/:activity_id", NotificationLive
  end

  scope "/api", DeliveryWeb do
    pipe_through :api

    post "/page/edit/:id", PageController, :write
    get "/question/:id", QuestionController, :read
    post "/question/:id", QuestionController, :write

    get "/packages/:package_id/activities/:activity_id", ActivityController, :read_api
    get "/packages/:package_id/activities/:activity_id/edit", ActivityController, :read_api

    get "/snippets", SnippetController, :read_all
    post "/snippets", SnippetController, :write
    post "/sound", SoundController, :write

  end
end
