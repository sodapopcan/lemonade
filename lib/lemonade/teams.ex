defmodule Lemonade.Teams do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.{Team, TeamMember}
  alias Lemonade.Teams.Standups

  def load_board(user) do
    if user.organization_id do
      team =
        Repo.one(
          from t in Team,
            where: t.organization_id == ^user.organization_id,
            preload: [
              :organization,
              [standup: [standup_members: :team_member]],
              [team_members: [:user]]
            ]
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

  defdelegate join_standup(standup, team_member), to: Standups
  defdelegate leave_standup(standup, team_member), to: Standups
end