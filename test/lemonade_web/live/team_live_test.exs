defmodule Lemonade.TeamLiveTest do
  use LemonadeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lemonade.OrganizationsFixtures

  @path "/team"

  setup :register_and_log_in_user

  setup %{user: user} do
    organization = bootstrapped_organization_fixture(user)

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

  describe "standup" do
    test "joining standup", %{conn: conn} do
      {:ok, view, _html} = live(conn, @path)

      view
      |> render_click("join-standup")

      refute render(view) =~ "join-standup-link"
    end

    test "leaving standup", %{conn: conn} do
      {:ok, view, _html}= live(conn, @path)

      view
      |> render_click("join-standup")

      view
      |> render_click("leave-standup")

      refute render(view) =~ "leave-standup-link"
    end
  end
end
