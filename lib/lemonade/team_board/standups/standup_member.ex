defmodule Lemonade.TeamBoard.Standups.StandupMember do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "standup_members" do
    belongs_to :standup, Lemonade.TeamBoard.Standups.Standup
    belongs_to :team_member, Lemonade.Organizations.TeamMember

    timestamps()
  end

  @doc false
  def changeset(standup_member, attrs) do
    standup_member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
