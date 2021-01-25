defmodule Lemonade.Repo.Migrations.FixStandupsAndStandupMembers do
  use Ecto.Migration

  def change do
    drop constraint(:standup_members, :standup_members_standup_id_fkey)

    alter table(:standup_members) do
      modify :standup_id, references(:standups, on_delete: :delete_all, type: :binary_id),
        null: false
    end

    drop constraint(:standups, :standups_team_id_fkey)

    alter table(:standups) do
      modify :team_id, references(:teams, on_delete: :delete_all, type: :binary_id),
        null: false
    end
  end
end
