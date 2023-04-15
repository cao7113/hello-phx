defmodule Hello.CryptoTest do
  use Hello.DataCase

  alias Hello.Crypto

  describe "tokens" do
    alias Hello.Crypto.Token

    import Hello.CryptoFixtures

    @invalid_attrs %{intro: nil, name: nil, url: nil}

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Crypto.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Crypto.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      valid_attrs = %{intro: "some intro", name: "some name", url: "some url"}

      assert {:ok, %Token{} = token} = Crypto.create_token(valid_attrs)
      assert token.intro == "some intro"
      assert token.name == "some name"
      assert token.url == "some url"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crypto.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()

      update_attrs = %{
        intro: "some updated intro",
        name: "some updated name",
        url: "some updated url"
      }

      assert {:ok, %Token{} = token} = Crypto.update_token(token, update_attrs)
      assert token.intro == "some updated intro"
      assert token.name == "some updated name"
      assert token.url == "some updated url"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Crypto.update_token(token, @invalid_attrs)
      assert token == Crypto.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Crypto.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Crypto.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Crypto.change_token(token)
    end
  end
end
