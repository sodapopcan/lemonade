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
    |> broadcast(:organization_member_updated)
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

  def broadcast({:error, _reason} = error, _event), do: error

  def broadcast({:ok, %{organization_id: organization_id} = entity}, event) do
    Phoenix.PubSub.broadcast(Lemonade.PubSub, "organization:#{organization_id}", {event, entity})
    {:ok, entity}
  end

  def broadcast({:ok, %{id: organization_id} = entity}, event) do
    Phoenix.PubSub.broadcast(Lemonade.PubSub, "organzation:#{organization_id}", {event, entity})
    {:ok, entity}
  end
end
