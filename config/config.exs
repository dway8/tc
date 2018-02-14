# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :app, ecto_repos: [App.Repo]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "q+YJWIzmULVdW3+l8Pf4EOh1dSgEmg4CuNd8GzMRsS/SzDF6F5rckfjAn4Q0jKK1",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: App.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :app, AppWeb.Auth.Guardian,
  issuer: "app",
  secret_key: "4YdcWnLgA/nntiRxYn2KeXB+lmdjYsJyHj68pp2vrBLDMIoLWfT01M/JcXiOoBhs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
