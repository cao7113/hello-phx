defmodule HelloPhxWeb.CommentController do
  use HelloPhxWeb, :controller

  alias HelloPhx.Blog
  alias HelloPhx.Blog.Comment

  def index(conn, _params) do
    comments = Blog.list_comments()
    render(conn, :index, comments: comments)
  end

  def new(conn, _params) do
    changeset = Blog.change_comment(%Comment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    case Blog.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/comments/#{comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    render(conn, :show, comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    changeset = Blog.change_comment(comment)
    render(conn, :edit, comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Blog.get_comment!(id)

    case Blog.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: ~p"/comments/#{comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    {:ok, _comment} = Blog.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/comments")
  end
end
