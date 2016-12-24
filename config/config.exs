use Mix.Config

# General application configuration
config :kai,
  ecto_repos: [Kai.Repo]

# Configures the endpoint
config :kai, Kai.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/TXJ3BNnLQSzsw+HhAxfBE4iCbdGcgL7CRHU3arr2tXVQqvAJu7SgJWdtOtgKVFq",
  render_errors: [view: Kai.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kai.PubSub, adapter: Phoenix.PubSub.PG2]

config :kai, Kai.Mailer,
  adapter: Bamboo.MailgunAdapter,
  domain: System.get_env("MAILGUN_DOMAIN"),
  api_key: System.get_env("MAILGUN_KEY")

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

# testing
config :hound, driver: "phantomjs"

# templates
config :slime, :keep_lines, true

#upload files
config :arc, 
  virtual_host: true,
  bucket: "kai-dev"

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  s3: [
    scheme: "https://",
    host: "s3-ap-southeast-2.amazonaws.com",
    region: "ap-southeast-2"
  ],
  debug_requests: true

config :ex_aws, :httpoison_opts,
  recv_timeout: 120_000,
  hackney: [recv_timeout: 120_000, pool: false]

config :porcelain, driver: Porcelain.Driver.Basic
config :toniq, redis_url: "redis://localhost:6379/0"
# config :toniq, redis_url: System.get_env("REDIS_PROVIDER")
#
config :ex_admin,
  repo: Kai.Repo,
  module: Kai,
  modules: [
    Kai.ExAdmin.Dashboard,
    Kai.ExAdmin.Food
  ]

import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

