defmodule Lemonade.Repo.Migrations.CreateTeamMembers do
  use Ecto.Migration

  def change do
    create table(:team_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :team_id, references(:teams, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:team_members, [:team_id, :user_id])
    create index(:team_members, [:user_id])
  end
end
