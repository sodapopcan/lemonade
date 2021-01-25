defmodule Lemonade.Repo.Migrations.AddPositionToStandups do
  use Ecto.Migration

  def change do
    alter table(:standups) do
      add :position, :integer
    end
  end
end
