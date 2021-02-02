defmodule Lemonade.Repo.Migrations.AddTimeZoneToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :time_zone, :string, default: "UTC"
    end
  end
end
