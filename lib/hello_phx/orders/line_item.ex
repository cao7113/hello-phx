defmodule HelloPhx.Orders.LineItem do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "order_line_items" do
    field :price, :decimal
    field :quantity, :integer

    belongs_to :order, HelloPhx.Orders.Order
    belongs_to :product, HelloPhx.Catalog.Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:price, :quantity])
    |> validate_required([:price, :quantity])
  end
end
