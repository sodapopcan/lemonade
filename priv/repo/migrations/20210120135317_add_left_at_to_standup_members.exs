defmodule Lemonade.Repo.Migrations.AddLeftAtToStandupMembers do
  use Ecto.Migration

  def change do
    alter table(:standup_members) do
      add :left_at, :naive_datetime
    end

    create index(:standup_members, :left_at)
  end
end
