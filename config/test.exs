use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kai, Kai.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kai, Kai.Repo,
  adapter: Ecto.Adapters.Postgres,
  #  username: System.get_env("PG_USERNAME"),
  #  password: System.get_env("PG_PASSWORD"),
  #  hostname: System.get_env("PG_HOST"),
  
  username: "postgres",
  password: "postgres",
  database: "kai_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
