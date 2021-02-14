defmodule Lemonade.Teams.Stickies do
  @moduledoc """
  The Teams.Stickies context.
  """

  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams.Stickies.StickyLane

  def list_sticky_lanes do
    Repo.all(StickyLane)
  end

  def create_sticky_lane(attrs \\ %{}) do
    %StickyLane{}
    |> StickyLane.changeset(attrs)
    |> Repo.insert()
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
