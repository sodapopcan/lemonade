defmodule Lemonade.Organizations do
  import Ecto.Query, warn: false
  alias Lemonade.Repo
  alias Ecto.Multi

  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Accounts

  def bootstrap_organization(%{name: name, email: email} = user, attrs) do
    result =
    Multi.new()
      |> Multi.insert(:organization, bootstrap_organization_changeset(user, attrs))
      |> Multi.run(:organization_members, fn repo, %{organization: organization} ->
        %OrganizationMember{organization: organization, user: user, added_by: user}
        |> OrganizationMember.changeset(%{name: name, email: email})
        |> repo.insert()
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
end
