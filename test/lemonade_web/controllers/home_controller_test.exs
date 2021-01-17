defmodule LemonadeWeb.HomeControllerTest do
  use LemonadeWeb.ConnCase, async: true

  import Lemonade.AccountsFixtures

  describe "GET /" do
    test "renders the homepage", %{conn: conn} do
      conn = get(conn, Routes.home_path(conn, :index))
      response = html_response(conn, 200)

      assert response =~ "Lemonade"
      assert response =~ "Login"
      assert response =~ "or"
      assert response =~ "Register"
    end
  end
end
