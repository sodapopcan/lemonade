defmodule Lemonade.Teams.StickiesTest do
  use Lemonade.DataCase

  alias Lemonade.Teams.Stickies

  describe "creating a sticky lane" do
    test "creates a sticky lane" do
      team = create(:team)

      {:ok, sticky_lane} = Lemonade.Teams.Stickies.create_sticky_lane(team)

      assert %{name: "New Lane", position: 1} = sticky_lane
    end
  end

  describe "creating a sticky" do
    test "creates a sticky" do
      sticky_lane = create(:sticky_lane)

      {:ok, sticky} = Lemonade.Teams.Stickies.create_sticky(sticky_lane, %{content: "Test note"})

      assert %{content: "Test note", position: 1} = sticky
    end
  end
end
