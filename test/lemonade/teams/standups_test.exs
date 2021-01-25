defmodule Lemonade.Teams.StandupsTest do
  use Lemonade.DataCase, async: true

  import Lemonade.OrganizationsFixtures

  alias Lemonade.Teams
  alias Teams.Standups
  alias Standups.Standup

  setup do
    user = create(:user)

    organization = bootstrapped_organization_fixture(user)

    [team | _] = organization.teams

    %{team: team}
  end

  describe "standups" do
    test "get standup by team", %{team: %{id: team_id} = team} do
      assert %Standup{team_id: ^team_id, standup_members: []} = Standups.get_standup_by_team(team)
    end

    test "joining and leaving standup", %{team: team} do
      %{standup: standup, team_members: [team_member | _]} = team

      {:ok, standup} = Standups.join_standup(standup, team_member)
      assert Enum.find(standup.standup_members, &(&1.team_member_id == team_member.id))

      {:ok, standup} = Standups.leave_standup(standup, team_member)
      refute Enum.find(standup.standup_members, &(&1.team_member_id == team_member.id))
    end
  end
end
