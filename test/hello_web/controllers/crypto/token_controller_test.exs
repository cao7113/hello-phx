defmodule HelloWeb.Crypto.TokenControllerTest do
  use HelloWeb.ConnCase

  import Hello.CryptoFixtures

  alias Hello.Crypto.Token

  @create_attrs %{
    intro: "some intro",
    name: "some name",
    url: "some url"
  }
  @update_attrs %{
    intro: "some updated intro",
    name: "some updated name",
    url: "some updated url"
  }
  @invalid_attrs %{intro: nil, name: nil, url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tokens", %{conn: conn} do
      conn = get(conn, ~p"/api/crypto/tokens")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create token" do
    test "renders token when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/crypto/tokens", token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/crypto/tokens/#{id}")

      assert %{
               "id" => ^id,
               "intro" => "some intro",
               "name" => "some name",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/crypto/tokens", token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update token" do
    setup [:create_token]

    test "renders token when data is valid", %{conn: conn, token: %Token{id: id} = token} do
      conn = put(conn, ~p"/api/crypto/tokens/#{token}", token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/crypto/tokens/#{id}")

      assert %{
               "id" => ^id,
               "intro" => "some updated intro",
               "name" => "some updated name",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, token: token} do
      conn = put(conn, ~p"/api/crypto/tokens/#{token}", token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete token" do
    setup [:create_token]

    test "deletes chosen token", %{conn: conn, token: token} do
      conn = delete(conn, ~p"/api/crypto/tokens/#{token}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/crypto/tokens/#{token}")
      end
    end
  end

  defp create_token(_) do
    token = token_fixture()
    %{token: token}
  end
end
