defmodule Lemonade.Repo.Migrations.AddPositionToStandupMembers do
  use Ecto.Migration

  def change do
    alter table(:standup_members) do
      add :position, :integer, default: 0, null: false
    end

    alter table(:standups) do
      remove :position
    end
  end
end
