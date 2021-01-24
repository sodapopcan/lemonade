defmodule Lemonade.Organizations do
  import Ecto.Query, warn: false
  alias Lemonade.Repo
  alias Ecto.Multi

  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Accounts
  alias Lemonade.Teams.Standups

  def bootstrap_organization(user, attrs) do
    result =
      Multi.new()
      |> Multi.insert(:organization, bootstrap_organization_changeset(user, attrs))
      |> Multi.run(:user, fn _repo, %{organization: organization} ->
        Accounts.join_organization(user, organization)
      end)
      |> Multi.run(:organization_member, fn _repo, %{organization: organization} ->
        join_organization(organization, user)
      end)
      |> Multi.run(:team_members, fn _repo,
                                     %{
                                       organization: %{teams: [team | _]},
                                       organization_member: organization_member
                                     } ->
        Lemonade.Teams.join_team(team, organization_member)
      end)
      |> Multi.run(:standup, fn _repo, %{organization: %{teams: [team | _]}} ->
        Standups.create_standup(team)
      end)
      |> Repo.transaction()

    case result do
      {:ok, %{organization: organization}} ->
        {:ok, organization |> Repo.preload([:organization_members, teams: [:team_members, :standup]])}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  def bootstrap_organization_changeset(user, attrs \\ %{}) do
    Organization.bootstrap_changeset(user, attrs)
  end

  def get_organization_by_user(user)do
    Repo.get_by(Organization, id: user.organization_id)
  end

  def get_organization_by_owner(user) do
    Repo.one(from Organization, where: [owned_by_id: ^user.id])
  end

  def get_organization_member_by_user(%{id: user_id}) do
    Repo.one(from OrganizationMember, where: [user_id: ^user_id])
  end

  def join_organization(organization, %{name: name, email: email} = user) do
    %OrganizationMember{organization: organization, user: user, added_by: user}
    |> OrganizationMember.changeset(%{name: name, email: email})
    |> Repo.insert()
  end
end
