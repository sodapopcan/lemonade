defmodule Lemonade.Organizations.TeamMember do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "team_members" do
    field :name, :string
    belongs_to :user, Lemonade.Accounts.User
    belongs_to :team, Lemonade.Organizations.Team
    has_one :standup_member, Lemonade.TeamBoard.Standups.StandupMember

    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def bootstrap_changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:name, :user_id])
  end
end
