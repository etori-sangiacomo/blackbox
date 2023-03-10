# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :blackbox,
  ecto_repos: [Blackbox.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :blackbox, BlackboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7WhiWGdpCUJXTJ5ZiQpxU+00tREctXh7cGM/H7Vfo6AEq3DK3ePX/oEFtfUNswL0",
  render_errors: [view: BlackboxWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Blackbox.PubSub,
  live_view: [signing_salt: "ohcFMZ3G"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :blackbox, Oban,
  repo: Blackbox.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
