defmodule Lemonade.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lemonade.Organizations` context.
  """

  alias Lemonade.Organizations

  def bootstrapped_organization_fixture(user, attrs \\ %{}) do
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

    organization
  end
end
