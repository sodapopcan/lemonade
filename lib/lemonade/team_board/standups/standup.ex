defmodule Lemonade.TeamBoard.Standups.Standup do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.TeamBoard.Standups.StandupMember

  schema "standups" do
    belongs_to :team, Lemonade.Organizations.Team
    has_many :standup_members, StandupMember

    timestamps()
  end

  @doc false
  def changeset(standup, attrs) do
    standup
    |> cast(attrs, [])
    |> validate_required([])
  end

  def bootstrap_changeset(standup, attrs) do
    standup
    |> changeset(attrs)
  end
end
