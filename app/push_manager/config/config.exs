# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :push_manager, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:push_manager, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
    import_config "#{Mix.env}.exs"

# config :apns,
# callback_module:    APNS.Callback,
# timeout:            30,
# feedback_interval:  1200,
# reconnect_after:    1000,
# support_old_ios:    true,
# pools: [
#   app1_dev_pool: [
#     env: :dev,
#     pool_size: 10,
#     pool_max_overflow: 5,
#     certfile: "keys/cert.pem",
#     keyfile: "keys/key.pem"
#   ]
# ]

# config :push_manager, PushManager.Repo,
# adapter: Ecto.Adapters.MySQL,
# username: "makeusmobile",
# password: "foretouch919293",
# database: "mks_common",
# hostname: "127.0.0.1",
# pool_size: 10
