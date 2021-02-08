defmodule Lemonade.Repo.Migrations.AddAvatarUrlToOrganizationMembers do
  use Ecto.Migration

  def change do
    alter table(:organization_members) do
      add :avatar_url, :string
    end
  end
end
