defmodule Lemonade.Teams.Stickies.StickyLane do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "sticky_lanes" do
    field :name, :string
    field :position, :integer
    belongs_to :team, Lemonade.Teams.Team
    has_many :stickies, Lemonade.Teams.Stickies.Sticky

    timestamps()
  end

  @doc false
  def changeset(sticky_lane, attrs) do
    sticky_lane
    |> cast(attrs, [:name, :position])
    |> validate_required([:name, :position])
  end
end
