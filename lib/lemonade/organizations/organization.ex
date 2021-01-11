defmodule Lemonade.Organizations.Organization do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    belongs_to :created_by, Lemonade.Accounts.User
    belongs_to :owned_by, Lemonade.Accounts.User
    field :creating_user, :map, virtual: true

    timestamps()
  end

  @doc false
  def create_changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :creating_user])
    |> validate_required([:name, :creating_user])
    |> put_user()
  end

  defp put_user(changeset) do
    creating_user = get_change(changeset, :creating_user)

    changeset
    |> put_change(:owned_by, creating_user)
    |> put_change(:created_by, creating_user)
  end
end
