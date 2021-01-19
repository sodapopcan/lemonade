defmodule Lemonade.TeamBoardTest do
  use Lemonade.DataCase

  alias Lemonade.TeamBoard
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

    %{user: user, attrs: attrs}
  end

  test "it loads the team board" do
  end

  test "joining standup", %{user: user, attrs: attrs} do
    Organizations.bootstrap_organization(user, attrs)

    user = Lemonade.Accounts.get_user_by_email(user.email)

    {:ok, team} = TeamBoard.load_board(user)
    %{standup: standup, team_members: [team_member | _]} = team

    {:ok, standup} = TeamBoard.join_standup(standup, team_member)

    assert Enum.any?(standup.standup_members, &(&1.team_member_id == team_member.id))
  end
end
