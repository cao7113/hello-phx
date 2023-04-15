defmodule HelloWeb.Crypto.TokenController do
  use HelloWeb, :controller

  alias Hello.Crypto
  alias Hello.Crypto.Token

  action_fallback HelloWeb.FallbackController

  def index(conn, _params) do
    tokens = Crypto.list_tokens()
    render(conn, :index, tokens: tokens)
  end

  def create(conn, %{"token" => token_params}) do
    with {:ok, %Token{} = token} <- Crypto.create_token(token_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/crypto/tokens/#{token}")
      |> render(:show, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    token = Crypto.get_token!(id)
    render(conn, :show, token: token)
  end

  def update(conn, %{"id" => id, "token" => token_params}) do
    token = Crypto.get_token!(id)

    with {:ok, %Token{} = token} <- Crypto.update_token(token, token_params) do
      render(conn, :show, token: token)
    end
  end

  def delete(conn, %{"id" => id}) do
    token = Crypto.get_token!(id)

    with {:ok, %Token{}} <- Crypto.delete_token(token) do
      send_resp(conn, :no_content, "")
    end
  end
end
