defmodule Lemonade.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.Organization

  def create_organization(user, attrs) do
    %Organization{created_by: user, owned_by: user}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

#   def change_organization(%Organization{} = organization, attrs \\ %{}) do
#     Organization.changeset(organization, attrs)
#   end
end
