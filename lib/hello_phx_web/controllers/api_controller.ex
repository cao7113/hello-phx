defmodule HelloPhxWeb.ApiController do
  use HelloPhxWeb, :controller

  action_fallback(HelloPhxWeb.FallbackController)

  def home(conn, _) do
    json(conn, HelloPhx.build_info())
  end

  def ping(conn, _params) do
    json(conn, %{
      msg: :pong
    })
  end

  def mock_404(_conn, _) do
    {:error, :not_found}
  end
end
