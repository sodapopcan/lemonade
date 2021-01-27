defmodule Lemonade.Organizations do
  import Ecto.Query, warn: false
  alias Lemonade.Repo
  alias Ecto.Multi

  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Accounts
  alias Lemonade.Teams.Standups

  def get_organization_by_organization_member(%OrganizationMember{} = organization_member) do
    Repo.one(from Organization, where: [id: ^organization_member.organization_id])
  end

  def get_organization_member_by_user(%Accounts.User{} = %{id: user_id}) do
    Repo.one(from OrganizationMember, where: [user_id: ^user_id])
  end

  def join_organization(organization, %{name: name, email: email} = user) do
    %OrganizationMember{organization: organization, user: user, added_by: user}
    |> OrganizationMember.changeset(%{name: name, email: email})
    |> Repo.insert()
  end

  @doc """
  Bootstraps an organization with the minimum require data to use the app.
  """
  def bootstrap_organization(user, attrs) do
    result =
      Multi.new()
      |> Multi.insert(:organization, bootstrap_organization_changeset(attrs))
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
        {:ok,
         organization |> Repo.preload([:organization_members, teams: [:team_members, :standup]])}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  def bootstrap_organization_changeset(attrs \\ %{}) do
    Organization.bootstrap_changeset(attrs)
  end
end
