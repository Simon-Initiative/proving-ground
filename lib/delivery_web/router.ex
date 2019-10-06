defmodule DeliveryWeb.Router do
  use DeliveryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DeliveryWeb do
    pipe_through :browser

    get "/", RootController, :index


    live "/packages", PackageLive.Index
    live "/packages/new", PackageLive.New
    live "/packages/:id/edit", PackageLive.Edit

    resources "/activities", ActivityController
    get "/edit/:id", EditController, :show

    live "/search", SearchLive
  end

  scope "/api", DeliveryWeb do
    pipe_through :api

    post "/edit/:id", EditController, :write

  end
end
