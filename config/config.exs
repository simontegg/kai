# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kai,
  ecto_repos: [Kai.Repo]

# Configures the endpoint
config :kai, Kai.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/TXJ3BNnLQSzsw+HhAxfBE4iCbdGcgL7CRHU3arr2tXVQqvAJu7SgJWdtOtgKVFq",
  render_errors: [view: Kai.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kai.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :kai,
  mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
  mailgun_key: System.get_env("MAILGUN_KEY")
  

config :slime, :keep_lines, true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
