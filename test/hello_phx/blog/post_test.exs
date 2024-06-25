defmodule HelloPhx.Blog.PostTest do
  use HelloPhx.DataCase, async: true
  alias HelloPhx.Blog.Post

  test "title must be at least two characters long" do
    changeset = Post.changeset(%Post{}, %{title: "I"})
    assert %{title: ["should be at least 2 character(s)"]} = errors_on(changeset)
  end
end
