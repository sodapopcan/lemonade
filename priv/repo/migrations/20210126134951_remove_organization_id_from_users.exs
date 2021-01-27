defmodule Lemonade.Repo.Migrations.RemoveOrganizationIdFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :organization_id
    end
  end
end
