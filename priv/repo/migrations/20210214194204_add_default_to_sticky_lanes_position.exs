defmodule Lemonade.Repo.Migrations.AddDefaultToStickyLanesPosition do
  use Ecto.Migration

  def change do
    alter table(:sticky_lanes) do
      modify :position, :integer, default: 0, null: false
    end
  end
end
