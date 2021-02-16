defmodule Lemonade.Teams.Stickies do
  @moduledoc """
  The Teams.Stickies context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Lemonade.Repo

  alias Lemonade.Teams.Stickies.{StickyLane, Sticky}


  def get_sticky_lane!(id), do: Repo.get!(StickyLane, id)

  def list_sticky_lanes(team) do
    Repo.all(
      from l in StickyLane,
        where: l.team_id == ^team.id,
        order_by: l.position,
        preload: [stickies: ^from(s in Sticky, order_by: s.position)]
    )
  end

  def create_sticky_lane(team) do
    {:ok, %{sticky_lane: sticky_lane}} =
      Multi.new()
      |> Multi.run(:position, fn _, _ -> {:ok, get_lane_position(team)} end)
      |> Multi.run(:sticky_lane, fn _, %{position: position} ->
        %StickyLane{team: team, name: "New Lane", position: position}
        |> Repo.insert()
      end)
      |> Repo.transaction()

    {:ok, sticky_lane}
    |> Lemonade.Teams.broadcast(:sticky_lanes_updated)
  end

  defp get_lane_position(%Lemonade.Teams.Team{} = team) do
    position =
      Repo.one(
        from l in StickyLane,
          select: max(l.position),
          where: l.team_id == ^team.id
      ) || 0

    position + 1
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

  def list_stickies do
    Repo.all(Sticky)
  end

  def get_sticky!(id), do: Repo.get!(Sticky, id)

  def create_sticky(sticky_lane, attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:position, fn _, _ -> {:ok, get_sticky_position(sticky_lane)} end)
    |> Multi.run(:sticky, fn _, %{position: position} ->
      %Sticky{sticky_lane: sticky_lane, position: position}
      |> change_sticky(attrs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{sticky: sticky}} ->
        sticky = Repo.preload(sticky, :sticky_lane)
        {:ok, sticky.sticky_lane}
        |> Lemonade.Teams.broadcast(:sticky_lanes_updated)

      error ->
        error
    end
  end

  defp get_sticky_position(%StickyLane{} = sticky_lane) do
    position =
      Repo.one(
        from l in Sticky,
          select: max(l.position),
          where: l.sticky_lane_id == ^sticky_lane.id
      ) || 0

    position + 1
  end

  def update_sticky(%Sticky{} = sticky, attrs) do
    sticky
    |> Sticky.changeset(attrs)
    |> Repo.update()
  end

  def delete_sticky(%Sticky{} = sticky) do
    Repo.delete(sticky)
  end

  def change_sticky(%Sticky{} = sticky, attrs \\ %{}) do
    Sticky.changeset(sticky, attrs)
  end
end
