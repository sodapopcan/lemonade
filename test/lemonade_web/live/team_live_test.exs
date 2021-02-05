defmodule Lemonade.TeamLiveTest do
  use LemonadeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lemonade.OrganizationsFixtures

  alias Lemonade.Teams

  @path "/team"

  setup :register_and_log_in_user

  setup %{user: user} do
    bootstrapped_organization_fixture(user)
  end

  test "disconnected and connected render", %{conn: conn, organization: organization} do
    {:ok, view, disconnected_html} = live(conn, @path)

    assert disconnected_html =~ organization.name
    assert render(view) =~ organization.name
  end

  test "bare state", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert render(view) =~ "join-standup-link"
  end

  describe "standup" do
    test "joining and leaving standup", %{conn: conn} do
      {:ok, view, _html} = live(conn, @path)

      view
      |> element(".join-standup-link")
      |> render_click()

      refute render(view) =~ "join-standup-link"

      view
      |> element(".leave-standup-link")
      |> render_click()

      refute render(view) =~ "leave-standup-link"
    end
  end

  describe "settings" do
    test "updating standup time", %{conn: conn, team: team} do
      {:ok, view, _html} = live(conn, "/team/settings")

      view
      |> form("form", %{
        team: %{
          name: "Delivery Team",
          standup: %{starts_at: "10:00"}
        }
      })
      |> render_submit()

      standup = Teams.get_standup_by_team(team)

      assert standup.starts_at == ~T[10:00:00]
    end
  end
end
