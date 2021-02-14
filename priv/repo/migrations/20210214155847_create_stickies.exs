defmodule Lemonade.Repo.Migrations.CreateStickies do
  use Ecto.Migration

  def change do
    create table(:stickies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :position, :integer
      add :color, :string
      add :completed, :boolean, default: false, null: false
      add :sticky_lane_id, references(:sticky_lanes, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:stickies, [:sticky_lane_id])
  end
end
