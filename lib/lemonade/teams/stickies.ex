defmodule Lemonade.Teams.Stickies do
  @moduledoc """
  The Teams.Stickies context.
  """

  import Ecto.Query, warn: false
  import Lemonade.Teams, only: [broadcast: 2]

  alias Lemonade.Repo

  alias Lemonade.Teams.Stickies.{StickyLane, Sticky}

  def get_sticky_lane!(id) do
    Repo.get!(StickyLane, id)
  end

  def list_sticky_lanes(team) do
    StickyLane.for_team_with_stickies(team)
    |> Repo.all()
  end

  def create_sticky_lane(team) do
    position = Repo.one(StickyLane.next_position(team))

    %StickyLane{team: team, name: "New Lane", position: position}
    |> Repo.insert()
    |> broadcast(:sticky_lanes_updated)
  end

  def update_sticky_lane(%StickyLane{} = sticky_lane, attrs) do
    sticky_lane
    |> StickyLane.changeset(attrs)
    |> Repo.update()
    |> broadcast(:sticky_lanes_updated)
  end

  def delete_sticky_lane(id) when is_binary(id) do
    get_sticky_lane!(id)
    |> Repo.preload(:team)
    |> delete_sticky_lane()
    |> broadcast(:sticky_lanes_updated)
  end

  def delete_sticky_lane(%StickyLane{} = sticky_lane) do
    Repo.delete(sticky_lane)
  end

  def change_sticky_lane(%StickyLane{} = sticky_lane, attrs \\ %{}) do
    StickyLane.changeset(sticky_lane, attrs)
  end

  def get_sticky!(id), do: Repo.get!(Sticky, id)

  def create_sticky(sticky_lane, attrs \\ %{}) do
    position = Repo.one(Sticky.next_position(sticky_lane))

    %Sticky{sticky_lane: sticky_lane, position: position}
    |> change_sticky(attrs)
    |> Repo.insert!()
    |> get_sticky_lane_from_sticky()
    |> broadcast(:sticky_lanes_updated)
  end

  defp preload_stickies(query) do
    Repo.preload(query, stickies: Sticky.ordered())
  end

  defp get_sticky_lane_from_sticky(sticky) do
    sticky_lane =
      sticky.sticky_lane_id
      |> get_sticky_lane!()
      |> preload_stickies()

    {:ok, sticky_lane}
  end

  def update_sticky(%Sticky{} = sticky, attrs) do
    sticky
    |> Sticky.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, sticky} ->
        {:ok, get_sticky_lane!(sticky.sticky_lane_id)}
        |> broadcast(:sticky_lanes_updated)

      error ->
        error
    end
  end

  def toggle_completed_sticky(%Sticky{} = sticky) do
    sticky
    |> Sticky.toggle_completed_changeset()
    |> Repo.update()
    |> case do
      {:ok, sticky} ->
        {:ok, get_sticky_lane!(sticky.sticky_lane_id)}
        |> broadcast(:sticky_lanes_updated)
    end
  end

  def delete_sticky(%Sticky{} = sticky) do
    sticky
    |> Repo.delete()
    |> case do
      {:ok, sticky} ->
        {:ok, get_sticky_lane!(sticky.sticky_lane_id)}
        |> broadcast(:sticky_lanes_updated)

      error ->
        error
    end
  end

  def move_sticky(sticky, sticky_lane, sticky_lane, new_position) do
    Sticky.for_lane(sticky_lane)
    |> Repo.all()
    |> move_sticky(sticky, new_position)
    |> update_stickies!()

    {:ok,
      %{
        team_id: sticky_lane.team_id,
        sticky_lanes: [preload_stickies(sticky_lane)]
      }
    }
    |> broadcast(:sticky_lanes_updated)
  end

  defp move_sticky(stickies, %Sticky{} = sticky, new_position)
      when is_list(stickies) and is_integer(new_position) do
    stickies
    |> Enum.reject(&(sticky.id == &1.id))
    |> List.insert_at(new_position - 1, sticky)
  end

  defp update_stickies!(stickies) do
    Repo.transaction(fn ->
      stickies
      |> Enum.with_index()
      |> Enum.each(fn {sticky, index} ->
        sticky
        |> change_sticky(%{position: index + 1})
        |> Repo.update!()
      end)
    end)
  end

  def change_sticky(%Sticky{} = sticky, attrs \\ %{}) do
    Sticky.changeset(sticky, attrs)
  end
end
