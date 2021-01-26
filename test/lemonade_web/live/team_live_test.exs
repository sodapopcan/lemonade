defmodule Lemonade.TeamLiveTest do
  use LemonadeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lemonade.OrganizationsFixtures

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
