defmodule Lemonade.Teams.Standups.StandupMember do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.TeamMember

  schema "standup_members" do
    belongs_to :standup, Lemonade.Teams.Standups.Standup
    belongs_to :team_member, TeamMember

    timestamps()
  end

  @doc false
  def changeset(standup_member, attrs) do
    standup_member
    |> cast(attrs, [:team_member_id])
    |> validate_required([])
  end
end
