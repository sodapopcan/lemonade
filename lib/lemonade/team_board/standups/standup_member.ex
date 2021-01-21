defmodule Lemonade.TeamBoard.Standups.StandupMember do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.TeamMember

  schema "standup_members" do
    belongs_to :standup, Lemonade.TeamBoard.Standups.Standup
    belongs_to :team_member, TeamMember
    field :left_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(standup_member, attrs) do
    standup_member
    |> cast(attrs, [:left_at, :team_member_id])
    |> validate_required([])
  end
end
