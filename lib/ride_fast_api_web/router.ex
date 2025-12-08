defmodule RideFastApiWeb.Router do
  use RideFastApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RideFastApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug RideFastApiWeb.Plugs.AuthPipeline
  end

  scope "/", RideFastApiWeb do
    pipe_through :browser

    get "/", PageController, :home

    resources "/users", UserController
    resources "/drivers", DriverController
  end

  scope "/api/v1", RideFastApiWeb do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
    get "/languages", LenguageController, :index
    get "/drivers", DriverController, :index
    get "/drivers/:driver_id/languages", DriverController, :drives_languages_index
  end

  scope "/api/v1", RideFastApiWeb do
    pipe_through [:api, :auth]

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    post "/drivers", DriverController, :create
    get "/drivers/:id", DriverController, :show
    put "/drivers/:id", DriverController, :update
    delete "/drivers/:id", DriverController, :delete

    get "/drivers/:driver_id/profile", DriverProfileController, :show
    post "/drivers/:driver_id/profile", DriverProfileController, :create
    put "/drivers/:driver_id/profile", DriverProfileController, :update

    get "/drivers/:driver_id/vehicles", VehicleController, :index
    post "/drivers/:driver_id/vehicles", VehicleController, :create
    put "/vehicles/:id", VehicleController, :update
    delete "/vehicles/:id", VehicleController, :delete

    post "/languages", LenguageController, :create
    post "/drivers/:driver_id/languages/:language_id", DriverLanguageController, :create
    delete "/drivers/:driver_id/languages/:language_id", DriverLanguageController, :delete

    post "/rides", RideController, :create
    get "/rides", RideController, :index
    get "/rides/:id", RideController, :show
    post "/rides/:id/accept", RideController, :accept
    post "/rides/:id/start", RideController, :start
    post "/rides/:id/complete", RideController, :complete
    post "/rides/:id/cancel", RideController, :cancel

    post "/rides/:id/ratings", RatingController, :create
    get "/rides/:id/ratings", RatingController, :index
    get "/drivers/:id/ratings", RatingController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", RideFastApiWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ride_fast_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RideFastApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
