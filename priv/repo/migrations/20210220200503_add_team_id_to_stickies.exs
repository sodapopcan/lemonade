defmodule Lemonade.Repo.Migrations.AddTeamIdToStickies do
  use Ecto.Migration

  def change do
    alter table(:stickies) do
      add :team_id, references(:teams, type: :binary_id, on_delete: :delete_all), null: false
    end
  end
end
