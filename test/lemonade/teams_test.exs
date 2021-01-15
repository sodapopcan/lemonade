defmodule Lemonade.TeamsTest do
  use Lemonade.DataCase

  alias Lemonade.Teams

  setup do
    user = create(:user)
    organization = create(:organization, %{created_by_id: user.id, owned_by_id: user.id})

    %{user: user, organization: organization}
  end

  describe "teams" do
    test "create a team", %{user: user, organization: organization} do
      {:ok, team} =
        Teams.create_team(user, organization, %{name: "Delivery Team"})

      assert team.name == "Delivery Team"
      assert %{created_by_id: user_id} = team
      assert user_id == user.id
    end

    test "gets a team by organization", %{organization: organization} do
      team = create(:team, organization: organization)

      found_team = Teams.get_team_by_organization(organization)

      assert team.id == found_team.id
    end
  end
end
