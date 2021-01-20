defmodule Lemonade.TeamBoardLiveTest do
  use LemonadeWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  @path "/team-board"

  setup :register_and_log_in_user

  setup %{user: user} do
    {:ok, organization} = Lemonade.Organizations.bootstrap_organization(user, %{
      "name" => "Planet Express",
      "teams" => [%{"name" => "Delivery Team"}]
    })

    %{organization: organization}
  end

  test "disconnected and connected render", %{conn: conn, organization: organization} do
    {:ok, view, disconnected_html} = live(conn, @path)

    assert disconnected_html =~ organization.name
    assert render(view) =~ organization.name
  end

  test "bare state", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert render(view) =~ "join standup"
  end

  test "joining standup", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> render_click("join-standup")

    refute render(view) =~ "join standup"
  end
end
