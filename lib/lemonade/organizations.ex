defmodule Lemonade.Organizations do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.{Organization, Team}
  alias Lemonade.Accounts

  def create_organization(user, attrs) do
    %Organization{created_by: user, owned_by: user}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

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
    %Organization{created_by: user, owned_by: user}
    |> Organization.bootstrap_changeset(attrs)
  end

  def get_organization_by_owner(user) do
    Repo.one(from Organization, where: [owned_by_id: ^user.id])
  end

  def create_team(user, organization, attrs) do
    %Team{organization: organization, created_by: user}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def get_team_by_organization(%{id: id}) do
    Repo.one(from Team, where: [organization_id: ^id])
  end
end
