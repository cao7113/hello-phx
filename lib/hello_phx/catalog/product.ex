defmodule HelloPhx.Catalog.Product do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  alias HelloPhx.Catalog.Category

  schema "products" do
    field :description, :string
    field :title, :string
    field :price, :decimal
    field :views, :integer, default: 0

    many_to_many :categories, Category, join_through: "product_categories", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :price, :views])
    |> validate_required([:title, :description, :price, :views])
  end
end
