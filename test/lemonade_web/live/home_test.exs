defmodule LemonadeWeb.HomeLiveTest do
  use LemonadeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, home_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Lemonade"
    assert render(home_live) =~ "Lemonade"
  end
end
