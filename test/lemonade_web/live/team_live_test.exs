defmodule Lemonade.TeamLiveTest do
  use LemonadeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lemonade.OrganizationsFixtures

  alias Lemonade.Teams

  @path "/team"

  setup :register_and_log_in_user

  setup %{user: user} do
    organization = bootstrapped_organization_fixture(user)
    organization_member = Lemonade.Organizations.get_organization_member_by_user(user)
    team = Teams.get_team_by_organization(organization)
    standup = Teams.get_standup_by_team(team)

    %{organization: organization, team: team, standup: standup}
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

  describe "standup" do
    test "joining and leaving standup", %{conn: conn} do
      {:ok, view, _html}= live(conn, @path)

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
end
