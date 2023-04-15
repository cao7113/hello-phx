defmodule Hello.Learn.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :intro, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :url, :intro])
    |> validate_required([:name, :url, :intro])
  end
end
