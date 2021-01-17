defmodule Lemonade.Organizations.Team do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.TeamMember

  schema "teams" do
    field :name, :string
    belongs_to :organization, Lemonade.Organizations.Organization
    has_many :team_members, TeamMember
    belongs_to :created_by, Lemonade.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def bootstrap_changeset(%{created_by: _created_by} = team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:team_members, required: true, with: &TeamMember.bootstrap_changeset/2)
  end
end
