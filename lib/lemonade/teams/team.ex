defmodule Lemonade.Teams.Team do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.Organization
  alias Lemonade.Teams.TeamMember
  alias Lemonade.Teams.Standups.Standup

  schema "teams" do
    field :name, :string
    belongs_to :organization, Organization
    has_many :team_members, TeamMember
    has_one :standup, Standup
    belongs_to :created_by, Lemonade.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 36)
    |> unique_constraint([:name, :organization_id])
  end

  def bootstrap_changeset(team, attrs) do
    team
    |> changeset(attrs)
    |> cast_assoc(:team_members, required: true, with: &TeamMember.bootstrap_changeset/2)
    |> cast_assoc(:standup, required: true, with: &Standup.bootstrap_changeset/2)
  end
end
