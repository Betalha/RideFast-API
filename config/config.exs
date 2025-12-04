# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phx_backend,
  ecto_repos: [PhxBackend.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :phx_backend, PhxBackendWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: PhxBackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PhxBackend.PubSub,
  live_view: [signing_salt: "lxQf7p7n"]


config :phx_backend, PhxBackend.Guardian,
  issuer: "phx_backend",
  secret_key: "S9mP-BxzeU6Y_IEYmX3_NzO3bhe79rSRvF059wUFiG1jJfkYneiHs0rXN7ku4JYc"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :phx_backend, PhxBackend.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
