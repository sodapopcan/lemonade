defmodule Lemonade.Teams.Standups.StandupMember do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Teams.{Standups, TeamMember}

  schema "standup_members" do
    field :name, :string
    field :position, :integer, default: 0
    belongs_to :standup, Standups.Standup
    belongs_to :team_member, TeamMember

    timestamps()
  end

  @doc false
  def changeset(standup_member, attrs) do
    standup_member
    |> cast(attrs, [:name, :position])
    |> validate_required([:name])
  end
end
