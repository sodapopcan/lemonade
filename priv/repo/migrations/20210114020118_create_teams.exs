defmodule Lemonade.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id)
      add :created_by_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:teams, [:organization_id])
  end
end
