# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :hello_phx,
  ecto_repos: [HelloPhx.Repo],
  generators: [timestamp_type: :utc_datetime]

config :hello_phx,
  build_mode: config_env(),
  build_time: DateTime.utc_now(),
  source_url: Mix.Project.config()[:source_url],
  commit_id: System.get_env("GIT_COMMIT_ID", ""),
  commit_time: System.get_env("GIT_COMMIT_TIME", "")

# Configures the endpoint
config :hello_phx, HelloPhxWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: HelloPhxWeb.ErrorHTML, json: HelloPhxWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: HelloPhx.PubSub,
  live_view: [signing_salt: "JVuGsbSU"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :hello_phx, HelloPhx.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  hello_phx: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  hello_phx: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

## deps
config :endon,
  repo: HelloPhx.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
