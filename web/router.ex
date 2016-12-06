defmodule Kai.Router do
  use Kai.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Kai do
    pipe_through [:browser, Kai.Auth] 

    get "/", PageController, :index
    resources "/users", UserController
    resources "/session", SessionController, only: [:new, :create, :show]
    resources "/session", SessionController, only: [:delete], singleton: true

  end
  # Other scopes may use custom stacks.
  # scope "/api", Kai do
    #   pipe_through :api
    # end
end
