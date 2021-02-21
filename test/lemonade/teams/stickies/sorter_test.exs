defmodule Lemonade.Teams.Stickies.SorterTest do
  use Lemonade.DataCase

  alias Lemonade.Teams.Stickies.Sorter

  describe "moving stickies" do
    test "move to a lower position within the same lane" do
      %{id: lane_id, team_id: team_id} = from_lane = create(:sticky_lane)
      %{id: id3} = sticky_3 = create(:sticky, sticky_lane: from_lane, position: 3)
      new_position = 1

      %{id: id1} = create(:sticky, sticky_lane: from_lane, position: 1)
      %{id: id2} = create(:sticky, sticky_lane: from_lane, position: 2)
      %{id: id4} = create(:sticky, sticky_lane: from_lane, position: 4)
      %{id: id5} = create(:sticky, sticky_lane: from_lane, position: 5)

      {:ok, result} = Sorter.move_sticky(sticky_3, from_lane, from_lane, new_position)

      assert(
        %{
          team_id: ^team_id,
          sticky_lanes: [
            %{
              id: ^lane_id,
              stickies: [
                %{id: ^id3, position: 1},
                %{id: ^id1, position: 2},
                %{id: ^id2, position: 3},
                %{id: ^id4, position: 4},
                %{id: ^id5, position: 5}
              ]
            }
          ]
        } = result
      )
    end

    test "move to a lower position on a different lane" do
      %{id: team_id} = team = create(:team)

      %{id: from_id} = from_lane = create(:sticky_lane, team: team, position: 1)
      %{id: to_id} = to_lane = create(:sticky_lane, team: team, position: 2)

      %{id: id1} = sticky = create(:sticky, sticky_lane: from_lane, position: 1)
      new_position = 2

      %{id: id2} = create(:sticky, sticky_lane: to_lane, position: 1)
      %{id: id3} = create(:sticky, sticky_lane: to_lane, position: 2)
      %{id: id4} = create(:sticky, sticky_lane: to_lane, position: 3)

      {:ok, result} = Sorter.move_sticky(sticky, from_lane, to_lane, new_position)

      assert(
        %{
          team_id: ^team_id,
          sticky_lanes: [
            %{
              id: ^from_id,
              stickies: []
            },
            %{
              id: ^to_id,
              stickies: [
                %{id: ^id2, position: 1},
                %{id: ^id1, position: 2},
                %{id: ^id3, position: 3},
                %{id: ^id4, position: 4}
              ]
            }
          ]
        } = result
      )
    end
  end
end
