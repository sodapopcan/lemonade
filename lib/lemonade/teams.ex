defmodule Lemonade.Teams do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams.{Team, TeamMember, Standups}

  def get_team_by_organization(%{id: id}) do
    Repo.get_by(Team, organization_id: id)
  end

  def get_team_member_by_organization_member(%{id: team_id}, %{id: organization_member_id}) do
    Repo.get_by(TeamMember, organization_member_id: organization_member_id, team_id: team_id)
  end

  def join_team(team, organization_member) do
    %TeamMember{team: team, organization_member: organization_member}
    |> TeamMember.changeset(%{name: organization_member.name})
    |> Repo.insert()
  end

  def create_team(user, organization, attrs) do
    %Team{organization: organization, created_by: user}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def subscribe(team_id) do
    Phoenix.PubSub.subscribe(Lemonade.PubSub, "team:#{team_id}")
  end

  def broadcast({:error, _reason} = error, _event), do: error
  def broadcast({:ok, %{team_id: team_id} = entity}, event) do
    Phoenix.PubSub.broadcast(Lemonade.PubSub, "team:#{team_id}", {event, entity})
    {:ok, entity}
  end

  defdelegate get_standup_by_team(team), to: Standups
  defdelegate join_standup(standup, team_member), to: Standups
  defdelegate leave_standup(standup, team_member), to: Standups
end
