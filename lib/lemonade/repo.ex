defmodule Lemonade.Repo do
  use Ecto.Repo,
    otp_app: :lemonade,
    adapter: Ecto.Adapters.Postgres
end
