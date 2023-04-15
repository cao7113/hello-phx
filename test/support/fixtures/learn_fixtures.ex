defmodule Hello.LearnFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hello.Learn` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        intro: "some intro",
        name: "some name",
        url: "some url"
      })
      |> Hello.Learn.create_book()

    book
  end
end
