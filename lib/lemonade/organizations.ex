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
    {:ok, organization} =
      %Organization{created_by: user, owned_by: user}
      |> Organization.bootstrap_changeset(attrs)
      |> Repo.insert()

    user
    |> Accounts.User.join_organization_changeset(organization)
    |> Repo.update()

    {:ok, organization}
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
