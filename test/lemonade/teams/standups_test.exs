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
  end

  describe "position" do
    test "increment position column" do
      team = create(:team)
      standup = create(:standup, team: team)
      %{id: team_member_1_id} = team_member_1 = create(:team_member, team: team)
      %{id: team_member_2_id} = team_member_2 = create(:team_member, team: team)

      {:ok, standup} = Standups.join_standup(standup, team_member_1)
      {:ok, standup} = Standups.join_standup(standup, team_member_2)

      assert [
               %{team_member_id: ^team_member_1_id, position: 1},
               %{team_member_id: ^team_member_2_id, position: 2}
             ] = standup.standup_members
    end

    test "get standup with preloaded members in the correct order" do
      team = create(:team)
      team_member = create(:team_member, team: team)
      standup = create(:standup, team: team)

      create_standup_member =
        &create(:standup_member, standup: standup, team_member: team_member, position: &1)

      %{id: id4} = create_standup_member.(4)
      %{id: id2} = create_standup_member.(2)
      %{id: id1} = create_standup_member.(1)
      %{id: id3} = create_standup_member.(3)

      standup = Standups.get_standup_by_team(team)

      assert [
               %{id: ^id1, position: 1},
               %{id: ^id2, position: 2},
               %{id: ^id3, position: 3},
               %{id: ^id4, position: 4}
             ] = standup.standup_members
    end
  end
end
