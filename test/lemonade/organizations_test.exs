defmodule Lemonade.OrganizationsTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.{Accounts, Organizations, Teams}
  alias Organizations.{Organization}
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
end
