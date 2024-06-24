defmodule HelloPhxWeb.PageController do
  use HelloPhxWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    # |> put_flash(:error, "Let's pretend we have an error.")
    |> render(:home, layout: false)
  end
end
