defmodule HelloPhx.Data do
  @moduledoc """
  Sample dev fixture data
  """

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: Faker.Lorem.sentence(),
        price:
          :rand.uniform()
          |> Decimal.from_float()
          |> Decimal.mult(Enum.random(1..100))
          |> Decimal.round(2),
        title: Faker.Person.name(),
        views: Enum.random(1..50)
      })
      |> HelloPhx.Catalog.create_product()

    product
  end

  def batch_gen(n \\ 3, tp \\ :product) do
    fun =
      case tp do
        :product -> &HelloPhx.Data.product_fixture/0
      end

    fun
    |> Stream.repeatedly()
    |> Enum.take(n)
  end
end
