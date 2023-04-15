defmodule HelloWeb.Crypto.TokenJSON do
  alias Hello.Crypto.Token

  @doc """
  Renders a list of tokens.
  """
  def index(%{tokens: tokens}) do
    %{data: for(token <- tokens, do: data(token))}
  end

  @doc """
  Renders a single token.
  """
  def show(%{token: token}) do
    %{data: data(token)}
  end

  defp data(%Token{} = token) do
    %{
      id: token.id,
      name: token.name,
      url: token.url,
      intro: token.intro
    }
  end
end
