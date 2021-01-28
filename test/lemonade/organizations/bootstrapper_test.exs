defmodule Lemonade.Organizations.BootstrapperTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.Organizations.{Bootstrapper, Organization, OrganizationMember}
  alias Lemonade.Teams.{Team, TeamMember}
  alias Lemonade.Teams.Standups.Standup

  describe "organization bootstrapper" do
    test "it works" do
      user = create(:user)

      attrs = %{
        "name" => "Planet Express",
        "teams" => [
          %{
            "name" => "Delivery Team",
          }
        ]
      }

      {:ok, organization} = Bootstrapper.bootstrap_organization(user, attrs)

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
