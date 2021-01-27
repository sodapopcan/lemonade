defmodule Lemonade.OrganizationsTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.{Organizations, Teams}
  alias Organizations.{Organization, OrganizationMember}
  alias Teams.{Team, TeamMember}
  alias Lemonade.Teams.Standups.{Standup}

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

    test "prevents duplication organization names", %{user: user, attrs: attrs} do
      Organizations.bootstrap_organization(user, attrs)
      {:error, errors} = Organizations.bootstrap_organization(user, attrs)

      assert %{errors: [name: {"has already been taken", _}]} = errors
    end

    test "bootstrap organization", %{user: user, attrs: attrs} do
      {:ok, organization} = Organizations.bootstrap_organization(user, attrs)

      %{id: user_id, name: user_name} = user

      assert %Organization{
               name: "Planet Express",
               created_by: ^user,
               owned_by: ^user,
               organization_members: [
                 %OrganizationMember{
                   id: organization_member_id,
                   user_id: ^user_id,
                   name: ^user_name
                 }
               ],
               teams: [
                 %Team{
                   name: "Delivery Team",
                   team_members: [
                     %TeamMember{
                       organization_member_id: organization_member_id,
                       name: ^user_name
                     }
                   ],
                   standup: %Standup{}
                 }
               ]
             } = organization
    end
  end
end
