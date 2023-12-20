defmodule SmolForumWeb.Router do
  use SmolForumWeb, :router

  import SmolForumWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SmolForumWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SmolForumWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/forum_boards", BoardLive.Index, :index
    live "/forum_boards/new", BoardLive.Index, :new
    live "/forum_boards/:id/edit", BoardLive.Index, :edit

    live "/forum_boards/:id", BoardLive.Show, :show
    live "/forum_boards/:id/show/edit", BoardLive.Show, :edit

    live "/forum_threads", ThreadLive.Index, :index
    live "/forum_threads/new", ThreadLive.Index, :new
    live "/forum_threads/:id/edit", ThreadLive.Index, :edit

    live "/forum_threads/:id", ThreadLive.Show, :show
    live "/forum_threads/:id/show/edit", ThreadLive.Show, :edit

    live "/forum_posts", PostLive.Index, :index
    live "/forum_posts/new", PostLive.Index, :new
    live "/forum_posts/:id/edit", PostLive.Index, :edit

    live "/forum_posts/:id", PostLive.Show, :show
    live "/forum_posts/:id/show/edit", PostLive.Show, :edit

  end

  # Other scopes may use custom stacks.
  # scope "/api", SmolForumWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:smol_forum, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SmolForumWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SmolForumWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SmolForumWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SmolForumWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SmolForumWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email


      live "/forum_boards/:id/new_thread", BoardLive.Show, :new_thread
    end
  end

  scope "/", SmolForumWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{SmolForumWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
