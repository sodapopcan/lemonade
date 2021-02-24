defmodule Lemonade.Teams.Stickies.Sorter do
  import Ecto.Query, warn: false
  import Lemonade.Teams, only: [broadcast: 2]

  alias Lemonade.Repo
  alias Lemonade.Teams.Stickies.{Sticky, StickyLane}

  def move_sticky(sticky, sticky_lane, sticky_lane, new_position) do
    sticky_lane
    |> preload_stickies()
    |> move_sticky(sticky, new_position)
    |> update_sticky_positions()

    {:ok,
     %{
       team_id: sticky_lane.team_id,
       sticky_lanes: [preload_stickies(sticky_lane)]
     }}
    |> broadcast(:sticky_lanes_updated)
  end

  def move_sticky(sticky, from_lane, to_lane, new_position) do
    Repo.transaction(fn ->
      sticky
      |> Sticky.change_lane_changeset(to_lane)
      |> Repo.update!()

      to_lane
      |> preload_stickies()
      |> move_sticky(sticky, new_position)
      |> update_sticky_positions()

      sticky_lanes =
        from(
          l in StickyLane.ordered(),
          where: l.id in [^from_lane.id, ^to_lane.id],
          preload: [stickies: ^Sticky.ordered()]
        )
        |> Repo.all()

      %{
        team_id: from_lane.team_id,
        sticky_lanes: sticky_lanes
      }
    end)
    |> broadcast(:sticky_lanes_updated)
  end

  defp move_sticky(%StickyLane{} = sticky_lane, %Sticky{} = sticky, new_position)
       when is_integer(new_position) do
    sticky_lane.stickies
    |> Enum.reject(&(sticky.id == &1.id))
    |> List.insert_at(new_position - 1, sticky)
  end

  def update_sticky_positions(stickies) do
    Repo.transaction(fn ->
      stickies
      |> Enum.with_index()
      |> Enum.each(fn {sticky, index} ->
        sticky
        |> Sticky.changeset(%{position: index + 1})
        |> Repo.update!()
      end)
    end)
  end

  defp preload_stickies(query) do
    Repo.preload(query, stickies: Sticky.ordered())
  end
end
