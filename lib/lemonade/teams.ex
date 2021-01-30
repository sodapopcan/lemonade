defmodule Lemonade.Teams do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams.{Team, TeamMember}

  def get_team_by_organization(%{id: id}) do
    Team
    |> Repo.get_by(organization_id: id)
  end

  def create_team(organization, attrs) do
    %Team{organization: organization}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def get_team_member_by_organization_member(%{id: team_id}, %{id: organization_member_id}) do
    TeamMember
    |> Repo.get_by(organization_member_id: organization_member_id, team_id: team_id)
  end

  def join_team(team, organization_member) do
    %TeamMember{team: team, organization_member: organization_member}
    |> TeamMember.changeset(%{name: organization_member.name})
    |> Repo.insert()
  end

  alias Lemonade.Teams.Standups

  defdelegate get_standup_by_team(team), to: Standups
  defdelegate join_standup(standup, team_member), to: Standups
  defdelegate leave_standup(standup, team_member), to: Standups
  defdelegate shuffle_standup(standup), to: Standups

  alias Lemonade.Teams.Vacation

  def book_vacation(team_member, attrs) do
    %Vacation{team_member: team_member, team_id: team_member.team_id}
    |> Vacation.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:vacation_updated)
  end

  def get_vacations_by_team(%Team{} = team) do
    from(v in Vacation, where: v.team_id == ^team.id, preload: :team_member)
    |> Repo.all()
  end

  def change_vacation(vacation, attrs) do
    vacation |> Vacation.changeset(attrs)
  end

  alias Lemonade.PubSub

  def subscribe(team_id) do
    Phoenix.PubSub.subscribe(PubSub, "team:#{team_id}")
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def broadcast({:ok, %{team_id: team_id} = entity}, event) do
    Phoenix.PubSub.broadcast(PubSub, "team:#{team_id}", {event, entity})
    {:ok, entity}
  end
end
