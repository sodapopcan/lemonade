defmodule Lemonade.Organizations.Organization do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    belongs_to :created_by, Lemonade.Accounts.User
    belongs_to :owned_by, Lemonade.Accounts.User
    field :creating_user_id, :binary_id, virtual: true

    timestamps()
  end

  @doc false
  def create_changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :creating_user_id])
    |> validate_required([:name, :creating_user_id])
    |> put_user()
  end

  defp put_user(changeset) do
    creating_user_id = get_change(changeset, :creating_user_id)

    changeset
    |> put_change(:owned_by_id, creating_user_id)
    |> put_change(:created_by_id, creating_user_id)
  end
end
