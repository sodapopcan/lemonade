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

  test "allows duplicate team names across organizations", %{organization: organization} do
    Teams.create_team(organization, %{name: "Delivery Team"})

    mom_corp = create(:organization, %{name: "Mom Corp"})

    assert {:ok, _} = Teams.create_team(mom_corp, %{name: "Delivery Team"})
  end

  test "gets a team by organization", %{team: team, organization: organization} do
    found_team = Teams.get_team_by_organization(organization)

    assert team.id == found_team.id
  end

  describe "vacations" do
    test "booking a vacation" do
      team_member = create(:team_member)
      %{id: team_member_id, team_id: team_id} = team_member

      {:ok, vacation} =
        Teams.book_vacation(team_member, %{
          starts_at: "2020-01-01 00:00:00",
          ends_at: "2020-01-01 00:00:00"
        })

      assert %{
               team_member_id: ^team_member_id,
               team_id: ^team_id,
               starts_at: ~N[2020-01-01 00:00:00],
               ends_at: ~N[2020-01-01 00:00:00],
               type: "all day"
             } = vacation
    end

    test "get by team" do
      team = create(:team)
      team_member = create(:team_member, name: "Philip Fry", team: team)

      create(
        :vacation,
        team: team,
        team_member: team_member,
        starts_at: ~N[2020-01-01 00:00:00],
        ends_at: ~N[2020-01-01 00:00:00]
      )

      vacations = Teams.get_vacations_by_team(team)

      assert [
        %{
          name: "Philip Fry",
          starts_at: ~N[2020-01-01 00:00:00],
          ends_at: ~N[2020-01-01 00:00:00],
          type: "all day"
        }
      ] = vacations
    end
  end
end
