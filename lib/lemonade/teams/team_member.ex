defmodule Lemonade.Teams.TeamMember do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Teams.{Team, Standups}
  alias Lemonade.Organizations.OrganizationMember

  schema "team_members" do
    field :name, :string
    belongs_to :organization_member, OrganizationMember
    belongs_to :team, Team
    has_one :standup_member, Standups.StandupMember

    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
