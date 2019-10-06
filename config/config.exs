# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :delivery,
  ecto_repos: [Delivery.Repo]

# Configures the endpoint
config :delivery, DeliveryWeb.Endpoint,
  live_view: [
    signing_salt: "SECRET_SALT"
  ],
  url: [host: "localhost"],
  secret_key_base: "yuF+XPAGjYM05OmpZMDwMxxQCzPZW6gPVs/NB6T3HHZu7q5SlGZShfB7z3/PiWwt",
  render_errors: [view: DeliveryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Delivery.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
