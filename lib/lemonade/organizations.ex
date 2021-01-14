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

  def get_organization_by_owner(user) do
    Repo.one(from Organization, where: [owned_by_id: ^user.id])
  end
end
