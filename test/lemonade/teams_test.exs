defmodule Lemonade.TeamsTest do
  use Lemonade.DataCase, async: true

  import Lemonade.OrganizationsFixtures

  alias Lemonade.Teams

  setup do
    user = create(:user)

    bootstrapped_organization_fixture(user)

    user = Lemonade.Accounts.get_user_by_email(user.email)

    {:ok, team} = Teams.load_board(user)

    %{user: user, team: team}
  end

  test "get team by user", %{user: user} do
    assert Teams.get_team_by_user(user)
  end

  test "get the current team member", %{user: user, team: team} do
    current_team_member = Teams.get_current_team_member(user, team)

    assert current_team_member.user == user
  end
end
