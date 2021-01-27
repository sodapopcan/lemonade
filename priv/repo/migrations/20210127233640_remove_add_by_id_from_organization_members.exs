defmodule Lemonade.Repo.Migrations.RemoveAddByIdFromOrganizationMembers do
  use Ecto.Migration

  def change do
    alter table(:organization_members) do
      remove :added_by_id
    end
  end
end
