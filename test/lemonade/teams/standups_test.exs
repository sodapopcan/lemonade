defmodule Lemonade.Teams.StandupsTest do
  use Lemonade.DataCase, async: true

  import Lemonade.OrganizationsFixtures

  alias Lemonade.Teams
  alias Teams.Standups
  alias Standups.{Standup, StandupMember}

  setup do
    user = create(:user)

    bootstrapped_organization_fixture(user)

    user = Lemonade.Accounts.get_user_by_email(user.email)

    {:ok, team} = Teams.load_board(user)

    %{team: team}
  end

  describe "standups" do
    test "get standup by team", %{team: %{id: team_id} = team} do
      assert %Standup{team_id: ^team_id, standup_members: []} = Standups.get_standup_by_team(team)
    end

    test "joining and leaving standup", %{team: team} do
      %{standup: standup, team_members: [team_member | _]} = team

      {:ok, standup} = Standups.join_standup(standup, team_member)
      standup_member = Enum.find(standup.standup_members, &(&1.team_member_id == team_member.id))

      assert standup_member

      leave_standup = Standups.leave_standup(standup, team_member)

      assert {:ok, %StandupMember{}} = leave_standup
    end
  end
end
