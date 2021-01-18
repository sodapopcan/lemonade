defmodule Lemonade.Repo.Migrations.AddNameToTeamMembers do
  use Ecto.Migration

  def change do
    alter table(:team_members) do
      add :name, :string, null: false
    end
  end
end
