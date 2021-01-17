defmodule Lemonade.Organizations.Organization do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.Team

  schema "organizations" do
    field :name, :string
    belongs_to :created_by, Lemonade.Accounts.User
    belongs_to :owned_by, Lemonade.Accounts.User
    has_many :teams, Team

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 36)
  end

  def bootstrap_changeset(%{created_by: created_by} = organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:teams,
      required: true,
      with: fn _team, attrs ->
        Team.bootstrap_changeset(%Team{created_by: created_by}, 
          Map.put(attrs, :team_members, [%{:user_id => created_by.id}])
        )
      end
    )
  end
end
