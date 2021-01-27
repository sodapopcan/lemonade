defmodule Lemonade.Organizations.Organization do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.OrganizationMember
  alias Lemonade.Teams.Team

  schema "organizations" do
    field :name, :string
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

  def bootstrap_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> cast_assoc(:teams, required: true)
  end
end
