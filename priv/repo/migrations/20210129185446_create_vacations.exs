defmodule Lemonade.Repo.Migrations.CreateVacations do
  use Ecto.Migration

  def change do
    create table(:vacations, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :starts_at, :naive_datetime, null: false
      add :ends_at, :naive_datetime, null: false
      add :type, :string, null: false
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id), null: false
      add :team_member_id, references(:team_members, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:vacations, [:team_id])
    create index(:vacations, [:team_member_id])
    create unique_index(:vacations, [:team_member_id, :starts_at])
    create unique_index(:vacations, [:team_member_id, :ends_at])
  end
end
