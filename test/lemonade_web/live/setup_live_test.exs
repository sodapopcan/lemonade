defmodule LemonadeWeb.PageLiveTest do
  use LemonadeWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/setup")
    assert disconnected_html =~ "<h1>Welcome</h1>"
    assert render(page_live) =~ "<h1>Welcome</h1>"
  end

  test "it does stuff", %{conn: conn, user: _user} do
    {:ok, view, _html} = live(conn, "/setup")

    view
    |> form("form", %{organization: %{name: "Planet Express"}})
    |> render_submit()
    |> assert =~ "<h1>Planet Express</h1>"
  end
end
