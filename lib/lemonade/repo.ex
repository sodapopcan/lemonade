defmodule Lemonade.Repo do
  use Ecto.Repo,
    otp_app: :lemonade,
    adapter: Ecto.Adapters.Postgres

  def first(query) do
    query
    |> Ecto.Query.first()
    |> one()
  end

  def last(query) do
    query
    |> Ecto.Query.last()
    |> one()
  end
end
