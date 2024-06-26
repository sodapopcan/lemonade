# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lemonade,
  ecto_repos: [Lemonade.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :lemonade, LemonadeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W7glJgrmegepRAWoM1IRX2/Iwg9TWz2dguTZSV2CWYFCsSfjF/qT5892YdvioI1A",
  render_errors: [view: LemonadeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lemonade.PubSub,
  live_view: [signing_salt: "3hD1YoXA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
