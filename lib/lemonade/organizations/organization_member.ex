defmodule Lemonade.Organizations.OrganizationMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organization_members" do
    field :email, :string
    field :name, :string
    belongs_to :organization, Lemonade.Organizations.Organization
    belongs_to :user, Lemonade.Accounts.User
    belongs_to :added_by, Lemonade.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(organization_member, attrs) do
    organization_member
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
