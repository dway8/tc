defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(AppWeb.Auth.Pipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  # Maybe logged in scope
  scope "/", AppWeb do
    pipe_through([:browser, :auth])

    get("/", PageController, :index)
    get("/login", PageController, :login)
    post("/login", PageController, :login_user)
    post("/logout", PageController, :logout)
  end

  # Definitely logged in scope
  scope "/", AppWeb do
    pipe_through([:browser, :auth, :ensure_auth])

    get("/admin", PageController, :admin)
  end

  forward("/api", Absinthe.Plug, schema: AppWeb.Schema)

  forward("/graphiql", Absinthe.Plug.GraphiQL, schema: AppWeb.Schema)

  # Other scopes may use custom stacks.
  # scope "/api", App do
  #   pipe_through :api
  # end
end
