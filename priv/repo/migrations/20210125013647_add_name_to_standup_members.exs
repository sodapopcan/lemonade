defmodule Lemonade.Repo.Migrations.AddNameToStandupMembers do
  use Ecto.Migration

  def change do
    alter table(:standup_members) do
      add :name, :string, null: false
    end
  end
end
