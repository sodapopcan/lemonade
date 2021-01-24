defmodule Lemonade.Repo.Migrations.AssociateTeamMembersWithOrgMembersAndRemoveUser do
  use Ecto.Migration

  def change do
    alter table(:team_members) do
      remove :user_id
      add :organization_member_id, references(:organization_members, on_delete: :delete_all, type: :binary_id), null: false
    end
  end
end
