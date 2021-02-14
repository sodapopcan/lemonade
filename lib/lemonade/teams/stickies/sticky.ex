defmodule Lemonade.Teams.Stickies.Sticky do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "stickies" do
    field :color, :string
    field :completed, :boolean, default: false
    field :content, :string
    field :position, :integer
    belongs_to :sticky_lane, Lemonade.Teams.Stickies.StickyLane

    timestamps()
  end

  @doc false
  def changeset(sticky, attrs) do
    sticky
    |> cast(attrs, [:content, :position, :color, :completed])
    |> validate_required([:content, :position, :color, :completed])
  end
end
