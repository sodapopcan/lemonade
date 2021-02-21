defmodule Lemonade.Teams.Stickies do
  @moduledoc """
  The Teams.Stickies context.
  """

  import Ecto.Query, warn: false
  import Lemonade.Teams, only: [broadcast: 2]

  alias Lemonade.Repo

  alias Lemonade.Teams.Stickies.StickyLane

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

  alias Lemonade.Teams.Stickies.Sticky

  def get_sticky!(id), do: Repo.get!(Sticky, id)

  def create_sticky(sticky_lane, attrs \\ %{}) do
    position = Repo.one(Sticky.next_position(sticky_lane))

    %Sticky{sticky_lane: sticky_lane, team_id: sticky_lane.team_id, position: position}
    |> Sticky.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:sticky_lanes_updated)
  end

  def update_sticky(%Sticky{} = sticky, attrs) do
    sticky
    |> Sticky.changeset(attrs)
    |> Repo.update()
    |> broadcast(:sticky_lanes_updated)
  end

  def toggle_completed_sticky(%Sticky{} = sticky) do
    sticky
    |> Sticky.toggle_completed_changeset()
    |> Repo.update()
    |> broadcast(:sticky_lanes_updated)
  end

  def delete_sticky(%Sticky{} = sticky) do
    sticky
    |> Repo.delete()
    |> broadcast(:sticky_lanes_updated)
  end
end
