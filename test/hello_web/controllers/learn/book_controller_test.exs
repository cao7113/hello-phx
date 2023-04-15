defmodule HelloWeb.Learn.BookControllerTest do
  use HelloWeb.ConnCase

  import Hello.LearnFixtures

  @create_attrs %{intro: "some intro", name: "some name", url: "some url"}
  @update_attrs %{intro: "some updated intro", name: "some updated name", url: "some updated url"}
  @invalid_attrs %{intro: nil, name: nil, url: nil}

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get(conn, ~p"/learn/books")
      assert html_response(conn, 200) =~ "Listing Books"
    end
  end

  describe "new book" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/learn/books/new")
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "create book" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/learn/books", book: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/learn/books/#{id}"

      conn = get(conn, ~p"/learn/books/#{id}")
      assert html_response(conn, 200) =~ "Book #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/learn/books", book: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "edit book" do
    setup [:create_book]

    test "renders form for editing chosen book", %{conn: conn, book: book} do
      conn = get(conn, ~p"/learn/books/#{book}/edit")
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "update book" do
    setup [:create_book]

    test "redirects when data is valid", %{conn: conn, book: book} do
      conn = put(conn, ~p"/learn/books/#{book}", book: @update_attrs)
      assert redirected_to(conn) == ~p"/learn/books/#{book}"

      conn = get(conn, ~p"/learn/books/#{book}")
      assert html_response(conn, 200) =~ "some updated intro"
    end

    test "renders errors when data is invalid", %{conn: conn, book: book} do
      conn = put(conn, ~p"/learn/books/#{book}", book: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete(conn, ~p"/learn/books/#{book}")
      assert redirected_to(conn) == ~p"/learn/books"

      assert_error_sent 404, fn ->
        get(conn, ~p"/learn/books/#{book}")
      end
    end
  end

  defp create_book(_) do
    book = book_fixture()
    %{book: book}
  end
end
