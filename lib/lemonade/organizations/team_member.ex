defmodule Lemonade.Organizations.TeamMember do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "team_members" do
    belongs_to :user, Lemonade.Accounts.User
    belongs_to :team, Lemonade.Organizations.Team

    timestamps()
  end

  @doc false
  def bootstrap_changeset(team_members, attrs) do
    team_members
    |> cast(attrs, [:user_id])
  end
end
