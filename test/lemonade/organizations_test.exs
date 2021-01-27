defmodule Lemonade.OrganizationsTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.{Organizations, Teams}
  alias Organizations.{Organization, OrganizationMember}
  alias Teams.{Team, TeamMember}
  alias Lemonade.Teams.Standups.{Standup}

  describe "organizations" do
    test "prevents duplication organization names" do
      create(:organization, name: "Planet Express")

      assert_raise Ecto.ConstraintError, fn ->
        create(:organization, name: "Planet Express")
      end
    end

    test "bootstrap organization" do
      user = create(:user)

      attrs = %{
        "name" => "Planet Express",
        "teams" => [
          %{
            "name" => "Delivery Team",
          }
        ]
      }

      {:ok, organization} = Organizations.bootstrap_organization(user, attrs)

      %{id: user_id, name: user_name} = user

      assert %Organization{
               name: "Planet Express",
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
