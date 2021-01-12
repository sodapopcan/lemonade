defmodule Lemonade.Organizations.Organization do
  use Lemonade.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    belongs_to :created_by, Lemonade.Accounts.User
    belongs_to :owned_by, Lemonade.Accounts.User

    timestamps()
  end

  @doc false
  def create_changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name, :created_by, :owned_by])
  end
end
