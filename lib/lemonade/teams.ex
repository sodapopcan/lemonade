defmodule Lemonade.Teams do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams.{Team, TeamMember, Standups}

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

  def get_team_by_user(user) do
    Team
    |> Repo.get_by(organization_id: user.organization_id)
    |> Repo.preload(:organization)
  end

  def get_current_team_member(user, team) do
    Repo.one(
      from m in TeamMember,
        where: m.user_id == ^user.id and m.team_id == ^team.id,
        preload: [:user]
    )
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
