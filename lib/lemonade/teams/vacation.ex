defmodule Lemonade.Teams.Vacation do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "vacations" do
    field :ends_at, :naive_datetime
    field :starts_at, :naive_datetime
    field :type, :string, default: "all day"
    belongs_to :team, Lemonade.Teams.Team
    belongs_to :team_member, Lemonade.Teams.TeamMember

    timestamps()
  end

  @doc false
  def changeset(vacation, attrs) do
    vacation
    |> cast(attrs, [:starts_at, :ends_at, :type])
    |> validate_required([:starts_at, :ends_at, :type])
  end
end
