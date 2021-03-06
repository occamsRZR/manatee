defmodule ManateeWeb.Router do
  use ManateeWeb, :router
  # , scope: "/admin", pipe_through: [:some_plug, :authenticate]
  use Kaffy.Routes

  import ManateeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ManateeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]

    resources "/location_weathers", LocationWeatherController, except: [:new, :edit]
  end

  pipeline :api_authenticated do
    plug ManateeWeb.AuthAccessPipeline
  end

  pipeline :graphql do
    plug ManateeWeb.Context
  end

  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: ManateeWeb.Schema
    resources "/application_products", ApplicationProductController, except: [:new, :edit]
  end

  scope "/", ManateeWeb do
    pipe_through :browser
    live "/", PageLive, :index
  end

  scope "/", ManateeWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/locations", LocationController

    live "/products", ProductLive.Index, :index
    live "/products/new", ProductLive.Index, :new
    live "/products/:id/edit", ProductLive.Index, :edit

    live "/products/:id", ProductLive.Show, :show
    live "/products/:id/show/edit", ProductLive.Show, :edit

    live "/areas", AreaLive.Index, :index
    live "/areas/new", AreaLive.Index, :new
    live "/areas/:id/edit", AreaLive.Index, :edit

    live "/areas/:id", AreaLive.Show, :show
    live "/areas/:id/show/edit", AreaLive.Show, :edit

    live "/applications", ApplicationLive.Index, :index
    live "/applications/new", ApplicationLive.Index, :new
    live "/applications/:id/edit", ApplicationLive.Index, :edit
    live "/applications/:id/add_products", ApplicationLive.Index, :add_products

    live "/applications/:id", ApplicationLive.Show, :show
    live "/applications/:id/show/edit", ApplicationLive.Show, :edit
    live "/applications/:id/show/add_products", ApplicationLive.Show, :add_products

    live "/applications/:id/delete_product/:application_product_id",
         ApplicationLive.Show,
         :delete_product

    live "/applications/:id/edit_product/:application_product_id",
         ApplicationLive.Show,
         :edit_product
  end

  # Other scopes may use custom stacks.
  # scope "/api", ManateeWeb do
  #   pipe_through :api
  # end

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
      live_dashboard "/dashboard", metrics: ManateeWeb.Telemetry, ecto_repos: [Manatee.Repo]
    end
  end

  ## Authentication routes

  scope "/", ManateeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :put_session_layout]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ManateeWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
    put "/users/settings/update_avatar", UserSettingsController, :update_avatar
  end

  scope "/", ManateeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  if Mix.env() == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: ManateeWeb.Schema
  end
end
