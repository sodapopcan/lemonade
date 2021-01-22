defmodule Lemonade.Repo.Migrations.RemoveLeftAtFromStandupMembers do
  use Ecto.Migration

  def change do
    alter table(:standup_members) do
      remove :left_at
    end
  end
end
