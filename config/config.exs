# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :manatee, ecto_repos: [Manatee.Repo], generators: [binary_id: true]

# Configures the endpoint
config :manatee, ManateeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gezCztOVJKD3K7/pRxOCsVz2/26KpvIXP6iwcLAtR6kikK55jKMTPDbjxLrheGDc",
  render_errors: [view: ManateeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Manatee.PubSub,
  live_view: [signing_salt: "ywIHqVZp"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :manatee, Manatee.Guardian,
  issuer: "manatee",
  secret_key: "vs1Xz/d2MjSjQ9eZefS1RrR0eJjQbx4cI0o1qg3Ulq0oKLWCoj/J5YXqDL31wxVW4es=",
  ttl: {3, :days}

config :manatee, ManateeWeb.AuthAccessPipeline,
  module: Manatee.Guardian,
  error_handler: ManateeWeb.AuthErrorHandler

config :ex_owm, api_key: System.get_env("OWM_API_KEY")

config :waffle,
  # or Waffle.Storage.Local
  storage: Waffle.Storage.S3,
  # if using S3
  bucket: System.get_env("AWS_BUCKET_NAME")

# If using S3:
config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

config :manatee, Manatee.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")

config :kaffy,
  otp_app: :manatee,
  ecto_repo: Manatee.Repo,
  router: ManateeWeb.Router

config :manatee, Oban,
  repo: Manatee.Repo,
  queues: [default: 1],
  plugins: [
    Oban.Plugins.Pruner
    # {Oban.Plugins.Cron,
    #  crontab: [
    #    {"0 6 * * *", Manatee.Workers.HistoricalWeatherWorker}
    #  ]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
