defmodule Lemonade.Repo.Migrations.DropCreatedByFromTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      remove :created_by_id
    end
  end
end
