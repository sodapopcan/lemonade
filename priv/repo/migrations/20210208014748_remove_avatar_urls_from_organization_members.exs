defmodule Lemonade.Repo.Migrations.RemoveAvatarUrlsFromOrganizationMembers do
  use Ecto.Migration

  def change do
    alter table(:organization_members) do
      remove :avatar_urls
    end
  end
end
