defmodule Lemonade.Repo.Migrations.AddMissingNullConstraints do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE teams ALTER COLUMN name SET NOT NULL")
    execute("ALTER TABLE teams ALTER COLUMN organization_id SET NOT NULL")
    execute("ALTER TABLE standup_members ALTER COLUMN team_member_id SET NOT NULL")
    execute("ALTER TABLE organization_members ALTER COLUMN name SET NOT NULL")
    execute("ALTER TABLE organization_members ALTER COLUMN email SET NOT NULL")
  end
end
