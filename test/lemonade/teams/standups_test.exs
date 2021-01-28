defmodule Lemonade.Teams.StandupsTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.Teams
  alias Teams.Standups
  alias Standups.Standup

  describe "standups" do
    test "get standup by team" do
      %{team: %{id: team_id} = team} = create(:standup)

      assert %Standup{team_id: ^team_id, standup_members: []} = Standups.get_standup_by_team(team)
    end

    test "joining and leaving standup" do
      standup = create(:standup)
      team = create(:team, standup: standup)
      team_member = create(:team_member, team: team)

      {:ok, standup} = Standups.join_standup(standup, team_member)
      assert team_member.id in Enum.map(standup.standup_members, & &1.team_member_id)

      {:ok, standup} = Standups.leave_standup(standup, team_member)
      refute team_member.id in Enum.map(standup.standup_members, & &1.team_member_id)
    end

#     test "incrementing position column" do
#       team = create(:team)
#       standup = create(:standup, team: team)
#       team_member_1 = create(:team_member, team: team)
#       team_member_2 = create(:team_member, team: team)

#       {:ok, standup} = Standups.join_standup(standup, team_member)
#       {:ok, standup} = Standups.join_standup(standup, team_member)
#     end
  end
end
