defmodule Lemonade.Repo.Migrations.CreateStandupMembers do
  use Ecto.Migration

  def change do
    create table(:standup_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :standup_id, references(:standups, on_delete: :nothing, type: :binary_id)
      add :team_member_id, references(:team_members, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:standup_members, [:standup_id])
    create index(:standup_members, [:team_member_id])
  end
end
