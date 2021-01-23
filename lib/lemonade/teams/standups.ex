defmodule Lemonade.Teams.Standups do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams
  alias Teams.Standups.{Standup, StandupMember}

  def get_standup_by_team(team) do
    Standup
    |> Repo.get_by(team_id: team.id)
    |> Repo.preload(standup_members: :team_member)
  end

  def join_standup(standup, team_member) do
    standup
    |> Standup.add_member_changeset(team_member)
    |> Repo.update()
    |> case do
      {:ok, standup} ->
        {:ok, Repo.preload(standup, standup_members: :team_member)}
        |> Teams.broadcast(:joined_standup)
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
end
