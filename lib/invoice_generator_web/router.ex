defmodule InvoiceGeneratorWeb.Router do
  use InvoiceGeneratorWeb, :router

  import InvoiceGeneratorWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {InvoiceGeneratorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", InvoiceGeneratorWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:invoice_generator, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: InvoiceGeneratorWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", InvoiceGeneratorWeb do
    pipe_through :browser

    live "/", HomeLive
  end

  ## Authentication routes

  scope "/", InvoiceGeneratorWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{InvoiceGeneratorWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/login", UserLoginLive, :new
      live "/register", UserRegistrationLive, :new
      live "/reset_password", UserForgotPasswordLive, :new
      live "/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/login", UserSessionController, :create
  end

  scope "/", InvoiceGeneratorWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{InvoiceGeneratorWeb.UserAuth, :ensure_authenticated}] do
      live "/settings", UserSettingsLive, :edit
      live "/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", InvoiceGeneratorWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{InvoiceGeneratorWeb.UserAuth, :mount_current_user}] do
      live "/confirm/:token", UserConfirmationLive, :edit
      live "/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
