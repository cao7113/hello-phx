defmodule HelloPhxWeb.ErrorJSONTest do
  use HelloPhxWeb.ConnCase, async: true

  test "renders 404" do
    assert HelloPhxWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Customized Not Found"}
           }
  end

  test "renders 500" do
    assert HelloPhxWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
