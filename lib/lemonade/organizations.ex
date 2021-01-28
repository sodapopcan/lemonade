defmodule Lemonade.Organizations do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.{Organization, OrganizationMember}
  alias Lemonade.Accounts

  def get_organization_by_organization_member(%OrganizationMember{} = organization_member) do
    Repo.one(from Organization, where: [id: ^organization_member.organization_id])
  end

  def get_organization_member_by_user(%Accounts.User{} = %{id: user_id}) do
    Repo.one(from OrganizationMember, where: [user_id: ^user_id])
  end

  defdelegate bootstrap_organization(user, attrs), to: Lemonade.Organizations.Bootstrapper
  defdelegate join_organization(organization, user), to: Lemonade.Organizations.Bootstrapper
  defdelegate bootstrap_organization_changeset(attrs), to: Lemonade.Organizations.Bootstrapper
end
