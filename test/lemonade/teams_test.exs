defmodule Lemonade.TeamsTest do
  use Lemonade.DataCase

  alias Lemonade.Teams

  describe "teams" do
    test "create a team" do
      user = create(:user)
      organization = create(:organization, %{created_by_id: user.id, owned_by_id: user.id})

      {:ok, team} =
        Teams.create_team(user, organization, %{name: "Delivery Team"})

      assert %{created_by_id: user_id} = team
      assert user_id == user.id
    end
  end
end
