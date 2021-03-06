use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :flaggy, Flaggy.Endpoint,
  http: [port: 9000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :flaggy, Flaggy.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :flaggy, Flaggy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "michelperez",
  password: "jokalive",
  database: "flaggy_dev",
  hostname: "localhost",
  pool_size: 10

config :flaggy,
  tmp_dir: System.tmp_dir,
  root_path: "#{System.cwd}/"

import_config "arc.exs"
import_config "oauth.exs"
