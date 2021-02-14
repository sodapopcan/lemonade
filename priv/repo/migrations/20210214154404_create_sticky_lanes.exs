defmodule Lemonade.Repo.Migrations.CreateStickyLanes do
  use Ecto.Migration

  def change do
    create table(:sticky_lanes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :position, :integer
      add :team_id, references(:teams, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:sticky_lanes, [:team_id])
    create unique_index(:sticky_lanes, [:name])
  end
end
