defmodule Lemonade.Organizations.OrganizationMember do
  use Lemonade.Schema
  import Ecto.Changeset

  alias Lemonade.Organizations.Organization
  alias Lemonade.Accounts.User

  schema "organization_members" do
    field :email, :string
    field :name, :string
    belongs_to :organization, Organization
    belongs_to :user, User
    belongs_to :added_by, User

    timestamps()
  end

  @doc false
  def changeset(organization_member, attrs) do
    organization_member
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
