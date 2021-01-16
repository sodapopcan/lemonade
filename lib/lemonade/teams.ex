defmodule Lemonade.Teams do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Teams.Team

  def create_team(user, organization, attrs) do
    %Team{organization: organization, created_by: user}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def get_team_by_organization(%{id: id}) do
    Repo.one(from Team, where: [organization_id: ^id])
  end
end