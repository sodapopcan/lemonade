defmodule Lemonade.Teams.Standups.Standup do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Teams.Standups.StandupMember

  schema "standups" do
    field :starts_at, :time
    field :randomized, :boolean, default: false
    field :last_randomized_at, :naive_datetime
    belongs_to :team, Lemonade.Teams.Team
    has_many :standup_members, StandupMember

    timestamps()
  end

  @doc false
  def changeset(standup, attrs) do
    standup
    |> cast(attrs, [:starts_at, :randomized, :last_randomized_at])
    |> validate_required([])
  end
end
