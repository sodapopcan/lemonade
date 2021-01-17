defmodule Lemonade.Repo.Migrations.AddOrganizationIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id)
    end
  end
end
