defmodule Lemonade.Repo.Migrations.CreateStandups do
  use Ecto.Migration

  def change do
    create table(:standups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:standups, [:team_id])
  end
end
