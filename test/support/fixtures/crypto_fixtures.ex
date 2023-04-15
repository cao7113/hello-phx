defmodule Hello.CryptoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hello.Crypto` context.
  """

  @doc """
  Generate a token.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        intro: "some intro",
        name: "some name",
        url: "some url"
      })
      |> Hello.Crypto.create_token()

    token
  end
end
