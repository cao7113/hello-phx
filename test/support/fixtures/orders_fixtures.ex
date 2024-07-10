defmodule HelloPhx.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelloPhx.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        total_price: "120.50",
        user_uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> HelloPhx.Orders.create_order()

    order
  end

  @doc """
  Generate a line_item.
  """
  def line_item_fixture(attrs \\ %{}) do
    {:ok, line_item} =
      attrs
      |> Enum.into(%{
        price: "120.50",
        quantity: 42
      })
      |> HelloPhx.Orders.create_line_item()

    line_item
  end
end
