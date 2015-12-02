use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :notification_api, NotificationApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :notification_api, NotificationApi.Repo,
adapter: Ecto.Adapters.MySQL,
username: "makeusmobile",
password: "foretouch919293",
database: "mks_common",
hostname: "127.0.0.1",
pool_size: 10
