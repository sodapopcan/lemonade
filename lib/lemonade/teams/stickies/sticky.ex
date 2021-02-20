defmodule Lemonade.Teams.Stickies.Sticky do
  @moduledoc false

  use Lemonade.Schema
  import Ecto.{Changeset, Query}

  schema "stickies" do
    field :color, :string, default: "yellow"
    field :completed, :boolean, default: false
    field :content, :string
    field :position, :integer
    belongs_to :sticky_lane, Lemonade.Teams.Stickies.StickyLane

    timestamps()
  end

  def changeset(sticky, attrs) do
    sticky
    |> cast(attrs, [:content, :position, :color, :completed])
    |> validate_required([:content, :position, :color, :completed])
  end

  def toggle_completed_changeset(sticky) do
    sticky
    |> change(%{completed: !sticky.completed})
  end

  def for_lane(sticky_lane) do
    from s in __MODULE__,
      where: s.sticky_lane_id == ^sticky_lane.id,
      order_by: s.position
  end

  def ordered do
    from s in __MODULE__,
      order_by: s.position
  end

  def next_position(sticky_lane) do
    from s in __MODULE__,
      select: coalesce(max(s.position), 0) + 1,
      where: s.sticky_lane_id == ^sticky_lane.id
  end
end
