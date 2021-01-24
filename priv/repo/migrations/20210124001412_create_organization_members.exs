defmodule Lemonade.Repo.Migrations.CreateOrganizationMembers do
  use Ecto.Migration

  def change do
    create table(:organization_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :added_by_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:organization_members, [:user_id])
    create index(:organization_members, [:added_by_id])
    create unique_index(:organization_members, [:email])
  end
end
