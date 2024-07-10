defmodule HelloPhxWeb.Api.UserController do
  use HelloPhxWeb, :controller

  action_fallback HelloPhxWeb.FallbackController

  def current(conn, _params) do
    data =
      if user = conn.assigns.current_user do
        %{
          current_user_email: user.email
        }
      else
        %{}
      end
      |> Map.put(:msg, :ok)

    json(conn, data)
  end
end
