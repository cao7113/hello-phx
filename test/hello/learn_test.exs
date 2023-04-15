defmodule Hello.LearnTest do
  use Hello.DataCase

  alias Hello.Learn

  describe "books" do
    alias Hello.Learn.Book

    import Hello.LearnFixtures

    @invalid_attrs %{intro: nil, name: nil, url: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Learn.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Learn.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{intro: "some intro", name: "some name", url: "some url"}

      assert {:ok, %Book{} = book} = Learn.create_book(valid_attrs)
      assert book.intro == "some intro"
      assert book.name == "some name"
      assert book.url == "some url"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{intro: "some updated intro", name: "some updated name", url: "some updated url"}

      assert {:ok, %Book{} = book} = Learn.update_book(book, update_attrs)
      assert book.intro == "some updated intro"
      assert book.name == "some updated name"
      assert book.url == "some updated url"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_book(book, @invalid_attrs)
      assert book == Learn.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Learn.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Learn.change_book(book)
    end
  end
end
