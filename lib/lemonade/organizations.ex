defmodule Lemonade.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.Organization

  def create_organization(user, attrs) do
    %Organization{}
    |> Map.put(:created_by_id, user.id)
    |> Map.put(:owned_by_id, user.id)
    |> Organization.create_changeset(attrs)
    |> Repo.insert()
  end

end
