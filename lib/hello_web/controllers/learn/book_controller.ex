defmodule HelloWeb.Learn.BookController do
  use HelloWeb, :controller

  alias Hello.Learn
  alias Hello.Learn.Book

  def index(conn, _params) do
    books = Learn.list_books()
    render(conn, :index, books: books)
  end

  def new(conn, _params) do
    changeset = Learn.change_book(%Book{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"book" => book_params}) do
    case Learn.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: ~p"/learn/books/#{book}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    book = Learn.get_book!(id)
    render(conn, :show, book: book)
  end

  def edit(conn, %{"id" => id}) do
    book = Learn.get_book!(id)
    changeset = Learn.change_book(book)
    render(conn, :edit, book: book, changeset: changeset)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Learn.get_book!(id)

    case Learn.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: ~p"/learn/books/#{book}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, book: book, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Learn.get_book!(id)
    {:ok, _book} = Learn.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: ~p"/learn/books")
  end
end
