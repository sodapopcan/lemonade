defmodule Lemonade.Organizations do
  import Ecto.Query, warn: false
  alias Lemonade.Repo
  alias Ecto.Multi

  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Accounts

  def bootstrap_organization(user, attrs) do
    result =
    Multi.new()
      |> Multi.insert(:organization, bootstrap_organization_changeset(user, attrs))
      |> Multi.run(:organization_members, fn _repo, %{organization: organization} ->
        join_organization(organization, user)
      end)
      |> Repo.transaction()

    case result do
      {:ok, %{organization: organization}} ->
        {:ok, organization |> Repo.preload(:organization_members)}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  def bootstrap_organization_changeset(user, attrs \\ %{}) do
    Organization.bootstrap_changeset(user, attrs)
  end

  def get_organization_by_owner(user) do
    Repo.one(from Organization, where: [owned_by_id: ^user.id])
  end

  def join_organization(organization, %{name: name, email: email} = user) do
    %OrganizationMember{organization: organization, user: user, added_by: user}
    |> OrganizationMember.changeset(%{name: name, email: email})
    |> Repo.insert()
  end
end
