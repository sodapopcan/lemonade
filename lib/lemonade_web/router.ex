defmodule LemonadeWeb.Router do
  use LemonadeWeb, :router

  import LemonadeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LemonadeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", LemonadeWeb do
    pipe_through :browser

    get "/", HomeController, :index
  end

  scope "/", LemonadeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/setup", SetupLive, :index
    live "/team", TeamLive, :index
    live "/team/vacations", TeamLive, :vacations
    live "/team/vacations/:modal_id", TeamLive, :vacations
    live "/team/settings", TeamLive, :settings

    live "/user-settings", UserSettingsLive, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LemonadeWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", LemonadeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", LemonadeWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/user/settings", UserSettingsController, :edit
    put "/user/settings", UserSettingsController, :update
    get "/user-settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", LemonadeWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete
    get "/user-confirm", UserConfirmationController, :new
    post "/users-confirm", UserConfirmationController, :create
    get "/users-confirm/:token", UserConfirmationController, :confirm
  end
end
