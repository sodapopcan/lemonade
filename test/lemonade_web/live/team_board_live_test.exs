defmodule Lemonade.TeamBoardLiveTest do
  use LemonadeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  setup %{user: user} do
    Lemonade.Organizations.bootstrap_organization(user, %{
      "name" => "Planet Express",
      "teams" => [%{"name" => "Delivery Team"}]
    })
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/team-board")

    assert disconnected_html =~ "Planet Express"
    assert render(page_live) =~ "Planet Express"
  end
end
