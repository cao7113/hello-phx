defmodule HelloPhxWeb.Router do
  use HelloPhxWeb, :router

  import HelloPhxWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {HelloPhxWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
    plug(HelloPhxWeb.Plugs.Locale, "en")
  end

  pipeline :shopping_on_browser do
    plug(:browser)
    plug(:fetch_current_user_uuid)
    plug(:fetch_current_cart)
  end

  def fetch_current_user_uuid(conn, _opts) do
    if user_uuid = get_session(conn, :current_uuid) do
      assign(conn, :current_uuid, user_uuid)
    else
      new_uuid = Ecto.UUID.generate()

      conn
      |> assign(:current_uuid, new_uuid)
      |> put_session(:current_uuid, new_uuid)
    end
  end

  alias HelloPhx.ShoppingCart

  defp fetch_current_cart(conn, _opts) do
    if cart = ShoppingCart.get_cart_by_user_uuid(conn.assigns.current_uuid) do
      assign(conn, :cart, cart)
    else
      {:ok, new_cart} = ShoppingCart.create_cart(conn.assigns.current_uuid)
      assign(conn, :cart, new_cart)
    end
  end

  scope "/", HelloPhxWeb do
    pipe_through(:browser)

    get("/", PageController, :home)

    get("/hello", HelloController, :index)
    get("/hello/func", HelloController, :fun_component)
    get("/hello/text", HelloController, :text_action)
    get("/hello/no-layout", HelloController, :no_layout)
    get("/hello/mock-error", HelloController, :mock_error)
    get("/hello/:messenger", HelloController, :show)

    # Status code
    get("/statuses", StatusController, :index)
    get("/statuses/:code", StatusController, :show)

    # Blog posts
    resources("/posts", PostController)
    resources("/comments", CommentController)
  end

  ## Shopping routes

  scope "/", HelloPhxWeb do
    pipe_through(:shopping_on_browser)

    # catalog products
    resources("/products", ProductController)
    resources("/cart_items", CartItemController, only: [:create, :delete])
    get("/cart", CartController, :show)
    put("/cart", CartController, :update)
    resources("/orders", OrderController, only: [:create, :show])
  end

  ## API Routes

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", HelloPhxWeb do
    pipe_through(:api)
    get("/", ApiController, :home)
    get("/ping", ApiController, :ping)
    get("/mock-404", ApiController, :mock_404)

    resources("/urls", UrlController, except: [:new, :edit])
    resources("/articles", ArticleController, except: [:new, :edit])
  end

  scope "/api", HelloPhxWeb do
    pipe_through([:api, :fetch_api_user])

    get("/users/current", Api.UserController, :current)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hello_phx, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: HelloPhxWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", HelloPhxWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{HelloPhxWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", HelloPhxWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{HelloPhxWeb.UserAuth, :ensure_authenticated}] do
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
    end
  end

  scope "/", HelloPhxWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{HelloPhxWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end
end
