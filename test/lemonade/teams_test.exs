defmodule Lemonade.TeamsTest do
  use Lemonade.DataCase, async: true

  import Lemonade.OrganizationsFixtures

  alias Lemonade.Teams

  setup do
    bootstrapped_organization_fixture()
  end

  test "get the current team member", %{organization_member: organization_member, team: team} do
    team_member = Teams.get_team_member_by_organization_member(team, organization_member)

    assert team_member.organization_member_id == organization_member.id
  end

  test "create a team", %{organization: organization} do
    {:ok, team} = Teams.create_team(organization, %{name: "Delivery Team 2"})

    assert team.name == "Delivery Team 2"
  end

  test "prevents duplicate team names within the same organization", %{
    organization: organization
  } do
    Teams.create_team(organization, %{name: "Delivery Team"})
    {:error, errors} = Teams.create_team(organization, %{name: "Delivery Team"})

    assert %{errors: [name: {"has already been taken", _}]} = errors
  end

  test "allows duplicate team names across organizations", %{
    user: user,
    organization: organization
  } do
    Teams.create_team(organization, %{name: "Delivery Team"})

    mom_corp =
      create(:organization, %{name: "Mom Corp", created_by_id: user.id, owned_by_id: user.id})

    assert {:ok, _} = Teams.create_team(mom_corp, %{name: "Delivery Team"})
  end

  test "gets a team by organization", %{team: team, organization: organization} do
    found_team = Teams.get_team_by_organization(organization)

    assert team.id == found_team.id
  end
end
