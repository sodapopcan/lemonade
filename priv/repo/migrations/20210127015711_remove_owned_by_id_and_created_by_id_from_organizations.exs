defmodule Lemonade.Repo.Migrations.RemoveOwnedByIdAndCreatedByIdFromOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      remove :owned_by_id
      remove :created_by_id
    end
  end
end
