defmodule LemonadeWeb.PageLiveTest do
  use LemonadeWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/setup")
    assert disconnected_html =~ "<h1>Welcome</h1>"
    assert render(page_live) =~ "<h1>Welcome</h1>"
  end

  describe "organization setup" do
    test "setup", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/setup")

      view
      |> form("form", %{organization: %{name: "Planet Express"}})
      |> render_submit()
      |> assert =~ "<h1>Planet Express</h1>"

      view
      |> form("form", %{team: %{name: "Devlivery Team"}})
      |> render_submit()
      |> assert =~ "<h1>Delivery Team</h1>"
    end
  end
end
