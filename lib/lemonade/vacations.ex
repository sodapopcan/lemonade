defmodule Lemonade.Teams.Vacations do
  import Ecto.Query, warn: false
  import Lemonade.Teams, only: [broadcast: 2]

  alias Lemonade.Repo
  alias Lemonade.Teams.{Team, TeamMember}
  alias Lemonade.Teams.Vacations.Vacation

  def book_vacation(team_member, attrs) do
    %Vacation{team_member: team_member, team_id: team_member.team_id}
    |> Vacation.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, vacation} ->
        {:ok, vacation |> Repo.preload(:team_member)}
        |> broadcast(:vacation_updated)

      error ->
        error
    end
  end

  def update_vacation(%Vacation{} = vacation, attrs) do
    vacation
    |> change_vacation(attrs)
    |> Repo.update()
    |> case do
      {:ok, vacation} ->
        {:ok, vacation |> Repo.preload(:team_member)}
        |> broadcast(:vacation_updated)

      error ->
        error
    end
  end

  def cancel_vacation(%Vacation{} = vacation) do
    vacation
    |> change_vacation(%{})
    |> Repo.delete()
    |> case do
      {:ok, vacation} ->
        {:ok, vacation} |> broadcast(:vacation_updated)

      error ->
        error
    end
  end

  def get_vacations_by_team(%Team{id: id}) do
    Repo.all(
      from v in Vacation,
        where: v.team_id == ^id,
        order_by: :starts_at,
        preload: :team_member
    )
  end

  def get_vacations_by_team_member(%TeamMember{id: id}) do
    from(v in Vacation, where: v.team_member_id == ^id, preload: :team_member)
    |> Repo.all()
  end

  def get_vacation!(id), do: Repo.get!(Vacation, id)

  def change_vacation(vacation, attrs) do
    vacation |> Vacation.changeset(attrs)
  end
end
