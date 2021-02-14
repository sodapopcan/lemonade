defmodule Lemonade.Teams.Stickies do
  @moduledoc """
  The Teams.Stickies context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Lemonade.Repo

  alias Lemonade.Teams.Stickies.StickyLane

  def list_sticky_lanes(team) do
    Repo.all(
      from l in StickyLane,
        where: l.team_id == ^team.id,
        order_by: l.position,
        preload: :stickies
    )
  end

  def create_sticky_lane(team) do
    {:ok, %{sticky_lane: sticky_lane}} =
      Multi.new()
      |> Multi.run(:position, fn _, _ -> {:ok, get_max_position(team)} end)
      |> Multi.run(:sticky_lane, fn _, %{position: position} ->
        %StickyLane{team: team, name: "New Lane", position: position}
        |> Repo.insert()
      end)
      |> Repo.transaction()

    {:ok, sticky_lane}
    |> Lemonade.Teams.broadcast(:sticky_lanes_updated)
  end

  defp get_max_position(team) do
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
  end

  def delete_sticky_lane(%StickyLane{} = sticky_lane) do
    Repo.delete(sticky_lane)
  end

  def change_sticky_lane(%StickyLane{} = sticky_lane, attrs \\ %{}) do
    StickyLane.changeset(sticky_lane, attrs)
  end

  alias Lemonade.Teams.Stickies.Sticky

  def list_stickies do
    Repo.all(Sticky)
  end

  def create_sticky(attrs \\ %{}) do
    %Sticky{}
    |> Sticky.changeset(attrs)
    |> Repo.insert()
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
