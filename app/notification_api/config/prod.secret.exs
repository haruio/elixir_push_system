use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :notification_api, NotificationApi.Endpoint,
  secret_key_base: "uKCgkeYzl9zv9rUDDuZd6GzVoTFJVaZD51y3N890CWC6DdyR5oijt6hhcTzRjbHM"

# Configure your database
config :notification_api, NotificationApi.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "notification_api_prod",
  pool_size: 20
