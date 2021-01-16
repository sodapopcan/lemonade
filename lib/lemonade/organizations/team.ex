defmodule Lemonade.Organizations.Team do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :organization, Lemonade.Organizations.Organization
    belongs_to :created_by, Lemonade.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
