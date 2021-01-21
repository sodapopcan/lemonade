defmodule Lemonade.TeamBoard.StandupsTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.Organizations
  alias Lemonade.TeamBoard
  alias TeamBoard.Standups

  setup do
    user = create(:user)

    Organizations.bootstrap_organization(
      user,
      %{
        "name" => "Planet Express",
        "teams" => [
          %{
            "name" => "Delivery Team"
          }
        ]
      }
    )

    user = Lemonade.Accounts.get_user_by_email(user.email)

    {:ok, team} = TeamBoard.load_board(user)

    %{team: team}
  end

  describe "standups" do
    test "joining and leaving standup", %{team: team} do
      %{standup: standup, team_members: [team_member | _]} = team

      {standup, team_member} = Standups.join_standup(standup, team_member)
      standup_member = Enum.find(standup.standup_members, & &1.team_member_id == team_member.id)

      assert standup_member
      refute standup_member.left_at

      standup_member = Standups.leave_standup(standup_member)

      assert standup_member.left_at
    end
  end
end
