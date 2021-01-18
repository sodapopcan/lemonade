defmodule Lemonade.Repo.Migrations.AddUniqueIndicesToOrganizationsAndTeams do
  use Ecto.Migration

  def change do
    create unique_index(:organizations, :name)
    create unique_index(:teams, [:name, :organization_id])
  end
end
