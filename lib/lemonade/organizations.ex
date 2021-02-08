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

  def update_organization_member(
        %OrganizationMember{} = organization_member,
        attrs,
        after_save \\ &{:ok, &1}
      ) do
    organization_member
    |> OrganizationMember.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end

  defp after_save({:ok, organization_member}, func) do
    {:ok, _organization_member} = func.(organization_member)
  end

  defp after_save(error, _func), do: error

  def change_organization_member(%OrganizationMember{} = organization_member) do
    OrganizationMember.changeset(organization_member, %{})
  end

  defdelegate bootstrap_organization(user, attrs), to: Lemonade.Organizations.Bootstrapper
  defdelegate join_organization(organization, user), to: Lemonade.Organizations.Bootstrapper
  defdelegate bootstrap_organization_changeset(attrs), to: Lemonade.Organizations.Bootstrapper
end
