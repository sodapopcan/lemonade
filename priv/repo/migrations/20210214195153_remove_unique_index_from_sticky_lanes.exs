defmodule Lemonade.Repo.Migrations.RemoveUniqueIndexFromStickyLanes do
  use Ecto.Migration

  def change do
    drop index(:sticky_lanes, :name)
  end
end
