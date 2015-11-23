# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

 config :notification_api, NotificationApi.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "makeusmobile",
  password: "foretouch919293",
  database: "makeus_notification",
  hostname: "127.0.0.1",
  pool_size: 10


# Configures the endpoint
config :notification_api, NotificationApi.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "zpjNcxxlzzwab/CkuTrPAy4JUAt0fqeG5nmA61WpVLAddkOCKxh+AojYslHPR7W+",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: NotificationApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
