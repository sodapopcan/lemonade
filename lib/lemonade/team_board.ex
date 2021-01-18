defmodule Lemonade.TeamBoard do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.Team

  def load_board(user) do
    if user.organization_id do
      team = Repo.one(
        from t in Team,
          where: t.organization_id == ^user.organization_id,
          preload: [:organization, {:team_members, :user}]
      )

      {:ok, team}
    else
      {:error, "User does not belong to an organization"}
    end
  end
end
