defmodule Lemonade.Teams do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams.{Team, TeamMember, Stickies}

  def get_team_by_organization(%{id: id}) do
    Team
    |> Repo.get_by(organization_id: id)
    |> Repo.preload([:organization, standup: :standup_members])
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

  def edit_team_changeset(team) do
    team
    |> Repo.preload(:standup)
    |> change_team()
  end

  def update_team(team, attrs \\ %{}) do
    changeset =
      team
      |> Repo.preload(:standup)
      |> change_team(attrs)

    changeset
    |> Repo.update()
    |> case do
      {:ok, team} ->
        case changeset do
          %{changes: %{standup: _standup}} ->
            broadcast({:ok, team.standup |> Repo.reload() |> Repo.preload(:standup_members)}, :standup_updated)

          %{changes: %{name: _name}} ->
            broadcast({:ok, team |> Repo.reload()}, :team_updated)

          _ ->
            nil
        end

        {:ok, team}

      error ->
        error
    end
  end

  def change_team(team, attrs \\ %{}) do
    team
    |> Team.changeset(attrs)
  end

  alias Lemonade.Teams.Standups
  defdelegate get_standup_by_team(team), to: Standups
  defdelegate join_standup(standup, team_member), to: Standups
  defdelegate leave_standup(standup, team_member), to: Standups
  defdelegate shuffle_standup(standup), to: Standups
  defdelegate get_all_standups(), to: Standups

  alias Lemonade.Teams.Vacations
  defdelegate book_vacation(team_member, attrs), to: Vacations
  defdelegate update_vacation(vacation, attrs), to: Vacations
  defdelegate cancel_vacation(vacation), to: Vacations
  defdelegate get_vacations_by_team(team), to: Vacations
  defdelegate get_vacations_by_team_member(team_member), to: Vacations
  defdelegate get_vacation!(id), to: Vacations
  defdelegate change_vacation(vacation, attrs), to: Vacations

  alias Lemonade.Teams.Stickies
  defdelegate list_sticky_lanes(team), to: Stickies
  defdelegate get_sticky_lane!(id), to: Stickies
  defdelegate create_sticky_lane(team), to: Stickies
  defdelegate update_sticky_lane(sticky_lane, attrs), to: Stickies
  defdelegate delete_sticky_lane(arg), to: Stickies
  defdelegate change_sticky_lane(sticky_lane, args \\ %{}), to: Stickies
  defdelegate get_sticky!(id), to: Stickies
  defdelegate create_sticky(sticky_lane, attrs), to: Stickies
  defdelegate update_sticky(sticky, attrs), to: Stickies
  defdelegate toggle_completed_sticky(sticky), to: Stickies
  defdelegate delete_sticky(sticky), to: Stickies
  defdelegate move_sticky(sticky, from_lane, to_lane, new_position), to: Stickies.Sorter

  alias Lemonade.PubSub

  def subscribe(team_id) do
    Phoenix.PubSub.subscribe(PubSub, "team:#{team_id}")
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def broadcast({:ok, %{team_id: team_id} = entity}, event) do
    Phoenix.PubSub.broadcast(PubSub, "team:#{team_id}", {event, entity})
    {:ok, entity}
  end

  def broadcast({:ok, %Team{id: team_id} = entity}, event) do
    Phoenix.PubSub.broadcast(PubSub, "team:#{team_id}", {event, entity})
    {:ok, entity}
  end
end
