defmodule Lemonade.Organizations.TeamMember do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "team_members" do
    field :name, :string
    belongs_to :user, Lemonade.Accounts.User
    belongs_to :team, Lemonade.Organizations.Team

    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
