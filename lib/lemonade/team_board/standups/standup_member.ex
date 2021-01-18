defmodule Lemonade.TeamBoard.Standups.StandupMember do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "standup_members" do
    field :standup_id, :binary_id
    field :team_member_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(standup_member, attrs) do
    standup_member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
