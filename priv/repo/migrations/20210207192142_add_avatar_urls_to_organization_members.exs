defmodule Lemonade.Repo.Migrations.AddAvatarUrlsToOrganizationMembers do
  use Ecto.Migration

  def change do
    alter table(:organization_members) do
      add :avatar_urls, {:array, :string}, null: false, default: []
    end
  end
end
