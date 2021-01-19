defmodule Lemonade.OrganizationsTest do
  use Lemonade.DataCase

  alias Lemonade.{Accounts, Organizations}
  alias Organizations.{Organization, Team, TeamMember}
  alias Lemonade.TeamBoard.Standups.{Standup, StandupMember}

  describe "organizations" do
    setup do
      user = create(:user)

      attrs = %{
        "name" => "Planet Express",
        "teams" => [
          %{
            "name" => "Delivery Team",
          }
        ]
      }

      %{user: user, attrs: attrs}
    end

    test "bootstrap organization", %{user: user, attrs: attrs} do
      {:ok, organization} = Organizations.bootstrap_organization(user, attrs)

      %{id: user_id, name: user_name} = user

      assert %Organization{
               name: "Planet Express",
               created_by: ^user,
               owned_by: ^user,
               teams: [
                 %Team{
                   name: "Delivery Team",
                   created_by: ^user,
                   team_members: [%TeamMember{user_id: ^user_id, name: ^user_name}],
                   standup: %Standup{}
                 }
               ]
             } = organization

      user = Accounts.get_user!(user.id)

      assert user.organization_id == organization.id
    end

    test "prevents duplication organization names", %{user: user, attrs: attrs} do
      Organizations.bootstrap_organization(user, attrs)
      {:error, errors} = Organizations.bootstrap_organization(user, attrs)

      assert %{errors: [name: {"has already been taken", _}]} = errors
    end
  end

  describe "teams" do
    setup do
      user = create(:user)
      organization = create(:organization, %{created_by_id: user.id, owned_by_id: user.id})

      %{user: user, organization: organization}
    end

    test "create a team", %{user: user, organization: organization} do
      {:ok, team} = Organizations.create_team(user, organization, %{name: "Delivery Team"})

      assert team.name == "Delivery Team"
      assert %{created_by_id: user_id} = team
      assert user_id == user.id
    end

    test "prevents duplicate team names within the same organization", %{user: user, organization: organization} do
      Organizations.create_team(user, organization, %{name: "Delivery Team"})
      {:error, errors} = Organizations.create_team(user, organization, %{name: "Delivery Team"})

      assert %{errors: [name: {"has already been taken", _}]} = errors
    end

    test "allows duplicate team names across organizations", %{user: user, organization: organization} do
      Organizations.create_team(user, organization, %{name: "Delivery Team"})
      mom_corp = create(:organization, %{name: "Mom Corp", created_by_id: user.id, owned_by_id: user.id})

      assert {:ok, _} = Organizations.create_team(user, mom_corp, %{name: "Delivery Team"})
    end

    test "gets a team by organization", %{organization: organization} do
      team = create(:team, organization: organization)

      found_team = Organizations.get_team_by_organization(organization)

      assert team.id == found_team.id
    end
  end
end
