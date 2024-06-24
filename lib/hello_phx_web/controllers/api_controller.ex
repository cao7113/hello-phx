defmodule HelloPhxWeb.ApiController do
  use HelloPhxWeb, :controller

  action_fallback HelloPhxWeb.FallbackController

  def ping(conn, _params) do
    json(conn, %{
      msg: :pong
    })
  end
end
