defmodule Lemonade.Tenancy do
  import Ecto.Query, warn: false
  alias Lemonade.Repo

  def get_organization_member_from_user_token(user_token) when is_binary(user_token) do
    Lemonade.Accounts.get_user_by_session_token(user_token)
    |> Lemonade.Organizations.get_organization_member_by_user()
    |> Repo.preload(:organization)
  end
end
