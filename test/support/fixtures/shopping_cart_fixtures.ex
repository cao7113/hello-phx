defmodule HelloPhx.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelloPhx.ShoppingCart` context.
  """

  @doc """
  Generate a unique cart user_uuid.
  """
  def unique_cart_user_uuid do
    # raise "implement the logic to generate a unique cart user_uuid"
    # Ecto.UUID.generate()
    Ecto.UUID.generate()
  end

  @doc """
  Generate a cart.
  """
  def cart_fixture(user_uuid \\ nil) do
    {:ok, cart} =
      (user_uuid || unique_cart_user_uuid())
      |> HelloPhx.ShoppingCart.create_cart()

    cart
  end

  @doc """
  Generate a cart_item.
  """
  def cart_item_fixture(attrs \\ %{}) do
    {:ok, cart_item} =
      attrs
      |> Enum.into(%{
        price_when_carted: "120.50",
        quantity: 42
      })
      |> HelloPhx.ShoppingCart.create_cart_item()

    cart_item
  end
end
