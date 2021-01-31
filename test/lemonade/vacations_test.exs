defmodule Lemonade.Teams.VacationsTest do
  use Lemonade.DataCase, async: true

  alias Lemonade.Teams.Vacations

  describe "vacations" do
    test "booking a vacation" do
      team_member = create(:team_member)
      %{id: team_member_id, team_id: team_id} = team_member

      {:ok, vacation} =
        Vacations.book_vacation(team_member, %{
          starts_at: "2020-01-01 00:00:00",
          ends_at: "2020-01-01 00:00:00"
        })

      assert %{
               team_member_id: ^team_member_id,
               team_id: ^team_id,
               starts_at: ~N[2020-01-01 00:00:00],
               ends_at: ~N[2020-01-01 00:00:00],
               type: "all day"
             } = vacation
    end

    test "get by team" do
      team = create(:team)
      team_member = create(:team_member, name: "Philip Fry", team: team)

      create(
        :vacation,
        team: team,
        team_member: team_member,
        starts_at: ~N[2020-01-01 00:00:00],
        ends_at: ~N[2020-01-01 00:00:00]
      )

      vacations = Vacations.get_vacations_by_team(team)

      assert [
        %{
          team_member: %{name: "Philip Fry"},
          starts_at: ~N[2020-01-01 00:00:00],
          ends_at: ~N[2020-01-01 00:00:00],
          type: "all day"
        }
      ] = vacations
    end

    test "get by id" do
      vacation = create(:vacation)
      found_vacation = Vacations.get_vacation!(vacation.id)

      assert vacation.id == found_vacation.id
    end
  end
end
