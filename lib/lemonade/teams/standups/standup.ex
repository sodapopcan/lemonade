defmodule Lemonade.Teams.Standups.Standup do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Teams.Standups.StandupMember

  schema "standups" do
    belongs_to :team, Lemonade.Teams.Team
    has_many :standup_members, StandupMember

    timestamps()
  end

  @doc false
  def changeset(standup, attrs) do
    standup
    |> cast(attrs, [])
    |> validate_required([])
  end
end
