defmodule Lemonade.TeamBoard.Standups do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.TeamBoard.Standups.{Standup, StandupMember}

  def join_standup(standup, team_member) do
    standup
    |> Standup.add_member_changeset(team_member)
    |> Repo.update!()
    |> Repo.preload(standup_members: :team_member)
  end

  def leave_standup(standup_member) do
    standup_member
    |> StandupMember.changeset(%{left_at: DateTime.utc_now})
    |> Repo.update!()
  end
end
