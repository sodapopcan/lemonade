defmodule Lemonade.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.Organization

  def create_organization(user, attrs) do
    attrs = %{attrs | created_by: user, owned_by: user}

    %Organization{}
    |> Organization.create_changeset(attrs)
    |> Repo.insert()
  end

end
