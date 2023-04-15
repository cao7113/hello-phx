defmodule HelloWeb.ToolsController do
  use HelloWeb, :controller

  action_fallback HelloWeb.FallbackController

  def ping(conn, _params) do
    render(conn, :ping)
  end
end
