defmodule Lemonade.TeamsTest do
  use Lemonade.DataCase, async: true

  import Lemonade.OrganizationsFixtures

  alias Lemonade.Teams

  setup do
    user = create(:user)
    organization = bootstrapped_organization_fixture(user)

    %{
      teams: [team | _],
      organization_members: [organization_member | _]
    } = organization

    %{
      user: user,
      team: team,
      organization: organization,
      organization_member: organization_member
    }
  end

  test "get the current team member", %{organization_member: organization_member, team: team} do
    team_member = Teams.get_team_member_by_organization_member(team, organization_member)

    assert team_member.organization_member_id == organization_member.id
  end

  test "create a team", %{user: user, organization: organization} do
    {:ok, team} = Teams.create_team(user, organization, %{name: "Delivery Team 2"})

    assert team.name == "Delivery Team 2"
    assert %{created_by_id: user_id} = team
    assert user_id == user.id
  end

  test "prevents duplicate team names within the same organization", %{
    user: user,
    organization: organization
  } do
    Teams.create_team(user, organization, %{name: "Delivery Team"})
    {:error, errors} = Teams.create_team(user, organization, %{name: "Delivery Team"})

    assert %{errors: [name: {"has already been taken", _}]} = errors
  end

  test "allows duplicate team names across organizations", %{
    user: user,
    organization: organization
  } do
    Teams.create_team(user, organization, %{name: "Delivery Team"})

    mom_corp =
      create(:organization, %{name: "Mom Corp", created_by_id: user.id, owned_by_id: user.id})

    assert {:ok, _} = Teams.create_team(user, mom_corp, %{name: "Delivery Team"})
  end

  test "gets a team by organization", %{team: team, organization: organization} do
    found_team = Teams.get_team_by_organization(organization)

    assert team.id == found_team.id
  end
end
