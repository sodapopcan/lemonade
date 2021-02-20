defmodule Lemonade.Teams.Stickies.StickyLane do
  use Lemonade.Schema
  import Ecto.{Changeset, Query}

  alias Lemonade.Teams.Stickies.Sticky

  schema "sticky_lanes" do
    field :name, :string
    field :position, :integer
    belongs_to :team, Lemonade.Teams.Team
    has_many :stickies, Sticky

    timestamps()
  end

  @doc false
  def changeset(sticky_lane, attrs) do
    sticky_lane
    |> cast(attrs, [:name, :position])
    |> validate_required([:name, :position])
  end

  @doc false
  def for_team_with_stickies(team) do
    from l in __MODULE__,
      where: l.team_id == ^team.id,
      order_by: l.position,
      preload: [stickies: ^Sticky.ordered()]
  end

  @doc false
  def next_position(team) do
    from s in __MODULE__,
      select: coalesce(max(s.position), 0) + 1,
      where: s.team_id == ^team.id
  end
end
