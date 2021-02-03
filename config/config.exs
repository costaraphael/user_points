# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :user_points,
  ecto_repos: [UserPoints.Repo]

# Configures the endpoint
config :user_points, UserPointsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UGO7nK0PN0WpnXyL8iROZzpMwyP4AKKff+NJ9SjdPwQ/4l48TJvwGmFMAaGcDVco",
  render_errors: [view: UserPointsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: UserPoints.PubSub,
  live_view: [signing_salt: "9sw0NLPd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
