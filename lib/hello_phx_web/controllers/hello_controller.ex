defmodule HelloPhxWeb.HelloController do
  use HelloPhxWeb, :controller

  def index(conn, _) do
    render(conn, :index)
  end

  def show(conn, %{"messenger" => messenger} = _params) do
    render(conn, :show, messenger: messenger)
  end

  def fun_component(conn, _params) do
    render(conn, :fun_component)
  end

  def text_action(conn, _p) do
    text(conn, "hello text response!")
  end

  def no_layout(conn, _) do
    conn
    |> put_root_layout(false)
    |> put_layout(false)
    # |> put_root_layout(html: :admin)
    |> render(:no_layout)
  end

  def mock_error(_, _) do
    raise HelloPhxWeb.StatusCodeError, message: "mock error"
  end
end
