defmodule Lemonade.Organizations do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.Organization
  alias Lemonade.Accounts

  def bootstrap_organization(user, attrs) do
    multi =
      Ecto.Multi.new()
        |> Ecto.Multi.insert(:organization, bootstrap_organization_changeset(user, attrs))
        |> Ecto.Multi.run(:user, fn repo, %{organization: organization} ->
          user
          |> Accounts.User.join_organization_changeset(organization)
          |> repo.update()
        end)

    case Repo.transaction(multi) do
      {:ok, %{organization: organization}} -> {:ok, organization}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  def bootstrap_organization_changeset(user, attrs \\ %{}) do
    Organization.bootstrap_changeset(user, attrs)
  end

  def get_organization_by_owner(user) do
    Repo.one(from Organization, where: [owned_by_id: ^user.id])
  end
end
