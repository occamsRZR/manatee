use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :manatee, Manatee.Repo,
  username: "postgres",
  password: "postgres",
  database: "manatee_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :manatee, ManateeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :manatee, Manatee.Mailer,
  adapter: Bamboo.TestAdapter

# Dont run oban in tests
config :manatee, Oban, queues: false, plugins: false
