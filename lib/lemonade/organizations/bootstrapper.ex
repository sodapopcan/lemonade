defmodule Lemonade.Organizations.Bootstrapper do
  import Ecto.Query, warn: false
  alias Lemonade.Repo
  alias Ecto.Multi

  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Teams.Standups

  @doc """
  Bootstraps an organization with the minimum require data to use the app.
  """
  def bootstrap_organization(user, attrs) do
    result =
      Multi.new()
      |> Multi.insert(:organization, bootstrap_organization_changeset(attrs))
      |> Multi.run(:organization_member, fn _, %{organization: o} -> join_organization(o, user) end)
      |> Multi.run(:team_members, &join_team/2)
      |> Multi.run(:standup, &create_standup/2)
      |> Repo.transaction()

    case result do
      {:ok, %{organization: organization}} ->
        {:ok,
         organization |> Repo.preload([:organization_members, teams: [:team_members, :standup]])}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  def bootstrap_organization_changeset(attrs) do
    Organization.bootstrap_changeset(attrs)
  end

  def join_organization(organization, %{name: name, email: email} = user) do
    %OrganizationMember{organization: organization, user: user}
    |> OrganizationMember.changeset(%{name: name, email: email})
    |> Repo.insert()
  end

  defp join_team(_repo, %{
         organization: %{teams: [team | _]},
         organization_member: organization_member
       }) do
    Lemonade.Teams.join_team(team, organization_member)
  end

  defp create_standup(_repo, %{organization: %{teams: [team | _]}}) do
    Standups.create_standup(team)
  end
end
