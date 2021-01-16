defmodule Lemonade.OrganizationsTest do
  use Lemonade.DataCase

  alias Lemonade.Organizations

  describe "organizations" do
    test "creates and organization with a name, created_by, and owned_by set" do
      user = create(:user)

      {:ok, organization} = Organizations.create_organization(user, %{name: "Planet Express"})

      assert %{created_by_id: user_id, owned_by_id: user_id} = organization
      assert user_id == user.id
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

    test "gets a team by organization", %{organization: organization} do
      team = create(:team, organization: organization)

      found_team = Organizations.get_team_by_organization(organization)

      assert team.id == found_team.id
    end
  end
end
