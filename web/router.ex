defmodule Kai.Router do
  use Kai.Web, :router
  use ExAdmin.Router

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

    get "/", AppController, :index
    post "/biometrics", AppController, :create
    get "/preferences", AppController, :serve_preferences
    
    resources "/users", UserController
    resources "/session", SessionController, only: [:new, :create, :show]
    resources "/session", SessionController, only: [:delete], singleton: true
    resources "/receipts", ReceiptController

    # if Mix.env == :dev do
    #   forward "/sent-emails", Bamboo.EmailPreviewPlug
    # end
  end

  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes
  end

end
