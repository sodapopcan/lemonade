defmodule LemonadeWeb.SetupLiveTest do
  use LemonadeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/setup")

    assert disconnected_html =~ "Welcome</h1>"
    assert render(page_live) =~ "Welcome</h1>"
  end

  describe "organization setup" do
    test "setup", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/setup")

      params = %{
        organization: %{name: "Planet Express", teams: %{"0" => %{name: "Delivery Team"}}}
      }

      view
        |> form("form", params)
        |> render_submit()

      assert_redirected(view, "/team")
    end
  end
end
