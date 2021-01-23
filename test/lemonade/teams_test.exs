defmodule Lemonade.TeamsTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.Teams
  alias Lemonade.Organizations

  setup do
    user = create(:user)

    attrs = %{
      "name" => "Planet Express",
      "teams" => [
        %{
          "name" => "Delivery Team"
        }
      ]
    }

    Organizations.bootstrap_organization(user, attrs)

    user = Lemonade.Accounts.get_user_by_email(user.email)

    {:ok, team} = Teams.load_board(user)

    %{user: user, team: team}
  end

  test "get the current team member", %{user: user, team: team} do
    current_team_member = Teams.get_current_team_member(user, team)

    assert current_team_member.user == user
  end
end
