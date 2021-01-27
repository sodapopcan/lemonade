defmodule Lemonade.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lemonade.Organizations` context.
  """

  alias Lemonade.Organizations
  alias Lemonade.Organizations.Organization

  def bootstrapped_organization_fixture() do
    Lemonade.AccountsFixtures.user_fixture()
    |> bootstrapped_organization_fixture()
  end

  def bootstrapped_organization_fixture(%Lemonade.Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "Planet Express",
        teams: [
          %{
            name: "Delivery Team"
          }
        ]
      })

    {:ok, organization} = Organizations.bootstrap_organization(user, attrs)

    %{
      teams: [team | _],
      organization_members: [organization_member | _]
    } = organization

    %{
      user: Lemonade.Repo.reload(user),
      team: team,
      organization: organization,
      organization_member: organization_member
    }
  end

  @doc """
  This is only useful for one test that ensures the user gets an organization id.
  This is going away.
  """
  def organization_fixture(user, attrs \\ %{}) do
    attrs = attrs |> Enum.into(%{name: "Planet Express"})

    {:ok, organization} =
      %Organization{}
      |> Organization.changeset(attrs)
      |> Lemonade.Repo.insert()

    organization
  end

end
