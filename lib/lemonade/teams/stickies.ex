defmodule Lemonade.Teams.Stickies do
  @moduledoc """
  The Teams.Stickies context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
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
    |> Lemonade.Teams.broadcast(:sticky_lanes_updated)
  end

  def update_sticky_lane(%StickyLane{} = sticky_lane, attrs) do
    sticky_lane
    |> StickyLane.changeset(attrs)
    |> Repo.update()
    |> Lemonade.Teams.broadcast(:sticky_lanes_updated)
  end

  def delete_sticky_lane(id) when is_binary(id) do
    get_sticky_lane!(id)
    |> Repo.preload(:team)
    |> delete_sticky_lane()
    |> Lemonade.Teams.broadcast(:sticky_lanes_updated)
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
    |> Lemonade.Teams.broadcast(:sticky_lanes_updated)
  end

  defp preload_stickies(query) do
    Repo.preload(query, stickies: Sticky.ordered)
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
        |> Lemonade.Teams.broadcast(:sticky_lanes_updated)

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
        |> Lemonade.Teams.broadcast(:sticky_lanes_updated)
    end
  end

  def delete_sticky(%Sticky{} = sticky) do
    sticky
    |> Repo.delete()
    |> case do
      {:ok, sticky} ->
        {:ok, get_sticky_lane!(sticky.sticky_lane_id)}
        |> Lemonade.Teams.broadcast(:sticky_lanes_updated)

      error ->
        error
    end
  end

  def move_sticky(sticky, sticky_lane, sticky_lane, new_position) do
    sticky_lane
    |> preload_stickies()
  end

  def change_sticky(%Sticky{} = sticky, attrs \\ %{}) do
    Sticky.changeset(sticky, attrs)
  end
end
