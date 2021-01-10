defmodule Lemonade.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :created_by_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :owned_by_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:organizations, [:created_by_id])
    create index(:organizations, [:owned_by_id])
  end
end
