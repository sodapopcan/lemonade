defmodule Lemonade.TeamBoard do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.{Team, TeamMember}
  alias Lemonade.TeamBoard.Standups.Standup

  def load_board(user) do
    if user.organization_id do
      team =
        Repo.one(
          from t in Team,
            where: t.organization_id == ^user.organization_id,
            preload: [:organization, {:standup, :standup_members}, {:team_members, :user}]
        )

      {:ok, team}
    else
      {:error, "User does not belong to an organization"}
    end
  end

  def get_current_team_member(user, team) do
    Repo.one(
      from m in TeamMember,
        where: m.user_id == ^user.id and m.team_id == ^team.id,
        preload: [:user]
    )
  end

  def join_standup(standup, team_member) do
    standup
    |> Standup.add_member_changeset(team_member)
    |> Repo.update()
  end
end
