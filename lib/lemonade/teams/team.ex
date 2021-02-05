defmodule Lemonade.Teams.Team do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.Organization
  alias Lemonade.Teams.TeamMember
  alias Lemonade.Teams.Standups.Standup

  schema "teams" do
    field :name, :string
    field :time_zone, :string, default: "UTC"
    belongs_to :organization, Organization
    has_many :team_members, TeamMember
    has_one :standup, Standup

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> cast_assoc(:standup)
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 36)
    |> unique_constraint([:name, :organization_id])
  end
end
