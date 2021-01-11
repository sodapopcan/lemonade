defmodule Lemonade.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Lemonade.Repo

  alias Lemonade.Organizations.Organization

  def create_organization(attrs) do
    %Organization{}
    |> Organization.create_changeset(attrs)
    |> Repo.insert()
  end

end
