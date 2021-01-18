defmodule Lemonade.TeamBoard do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.Team

  def load_board(user) do
    Repo.one(
      from t in Team,
        where: t.organization_id == ^user.organization_id,
        preload: [:organization, {:team_members, :user}]
    )
  end
end
