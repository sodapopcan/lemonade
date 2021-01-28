defmodule Lemonade.Teams.Standups do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams
  alias Teams.Standups.{Standup, StandupMember}

  def get_standup_by_team(team) do
    Standup
    |> Repo.get_by(team_id: team.id)
    |> preload_standup_members()
  end

  def join_standup(standup, team_member) do
    %StandupMember{
      standup: standup,
      team_member: team_member,
      position: max_position(standup) + 1
    }
    |> StandupMember.changeset(%{name: team_member.name})
    |> Repo.insert()
    |> case do
      {:ok, _standup_member} ->
        standup = Repo.reload(standup) |> preload_standup_members()
        Teams.broadcast({:ok, standup}, :standup_updated)
        {:ok, standup}

      error ->
        error
    end
  end

  defp max_position(standup) do
    Repo.one(
      from m in StandupMember,
        where: m.standup_id == ^standup.id,
        select: m.position |> max() |> coalesce(0)
    )
  end

  defp preload_standup_members(standup) do
    standup
    |> Repo.preload(standup_members: from(StandupMember, order_by: :position))
  end

  def leave_standup(standup, team_member) do
    StandupMember
    |> Repo.get_by(team_member_id: team_member.id)
    |> Repo.delete()

    {:ok, Repo.reload(standup) |> preload_standup_members()}
    |> Teams.broadcast(:standup_updated)
  end

  @untested true
  def shuffle_standup(standup) do
    Repo.transaction(fn ->
      standup.standup_members
      |> Enum.shuffle()
      |> Enum.with_index()
      |> Enum.each(fn {member, index} ->
        member
        |> StandupMember.changeset(%{position: index + 1})
        |> Repo.update()
      end)

      standup = standup |> Repo.reload() |> preload_standup_members()

      Teams.broadcast({:ok, standup}, :standup_updated)
    end)
  end

  def create_standup(team) do
    %Standup{team: team}
    |> Standup.changeset(%{})
    |> Repo.insert()
  end
end
