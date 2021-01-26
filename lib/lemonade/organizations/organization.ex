defmodule Lemonade.Organizations.Organization do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.OrganizationMember
  alias Lemonade.Teams.Team
  alias Lemonade.Accounts.User

  schema "organizations" do
    field :name, :string
    belongs_to :created_by, User
    belongs_to :owned_by, User
    has_many :teams, Team
    has_many :organization_members, OrganizationMember

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 2, max: 36)
  end

  def bootstrap_changeset(user, attrs) do
    %__MODULE__{created_by: user, owned_by: user}
    |> changeset(attrs)
    |> cast_assoc(:teams)
  end
end
