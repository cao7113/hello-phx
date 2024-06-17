defmodule HelloPhxWeb.HelloController do
  use HelloPhxWeb, :controller

  def index(conn, _) do
    render(conn, :index)
  end

  def show(conn, %{"messenger" => messenger} = _params) do
    render(conn, :show, messenger: messenger, layout: false)
  end
end
