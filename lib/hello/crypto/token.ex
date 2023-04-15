defmodule Hello.Crypto.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :intro, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:name, :url, :intro])
    |> validate_required([:name, :url, :intro])
  end
end
