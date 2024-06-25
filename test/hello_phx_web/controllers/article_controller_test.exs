defmodule HelloPhxWeb.ArticleControllerTest do
  use HelloPhxWeb.ConnCase

  import HelloPhx.NewsFixtures

  alias HelloPhx.News.Article

  @create_attrs %{
    title: "some title",
    body: "some body"
  }
  @update_attrs %{
    title: "some updated title",
    body: "some updated body"
  }
  @invalid_attrs %{title: nil, body: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = get(conn, ~p"/api/articles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create article" do
    test "renders article when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/articles", article: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/articles/#{id}")

      assert %{
               "id" => ^id,
               "body" => "some body",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/articles", article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update article" do
    setup [:create_article]

    test "renders article when data is valid", %{conn: conn, article: %Article{id: id} = article} do
      conn = put(conn, ~p"/api/articles/#{article}", article: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/articles/#{id}")

      assert %{
               "id" => ^id,
               "body" => "some updated body",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = put(conn, ~p"/api/articles/#{article}", article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete article" do
    setup [:create_article]

    test "deletes chosen article", %{conn: conn, article: article} do
      conn = delete(conn, ~p"/api/articles/#{article}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/articles/#{article}")
      end
    end
  end

  defp create_article(_) do
    article = article_fixture()
    %{article: article}
  end
end
