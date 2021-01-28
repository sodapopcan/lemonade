defmodule Lemonade.Teams.Standups do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams
  alias Teams.Standups.{Standup, StandupMember}

  def get_standup_by_team(team) do
    Standup
    |> Repo.get_by(team_id: team.id)
    |> Repo.preload(:standup_members)
  end

  def join_standup(standup, team_member) do
    %StandupMember{standup: standup, team_member: team_member}
    |> StandupMember.changeset(%{name: team_member.name})
    |> Repo.insert()
    |> case do
      {:ok, _standup_member} ->
        standup = Repo.reload(standup) |> Repo.preload(:standup_members)
        Teams.broadcast({:ok, standup}, :joined_standup)
        {:ok, standup}

      error -> error
    end
  end

  def leave_standup(standup, team_member) do
    StandupMember
    |> Repo.get_by(team_member_id: team_member.id)
    |> Repo.delete()

    {:ok, Repo.reload(standup) |> Repo.preload(:standup_members)}
    |> Teams.broadcast(:left_standup)
  end

  def create_standup(team) do
    %Standup{team: team}
    |> Standup.changeset(%{})
    |> Repo.insert()
  end
end
