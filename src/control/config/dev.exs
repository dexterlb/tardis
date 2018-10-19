use Mix.Config

config :server,
  root_target: :global_registry,
  dev_proxy: true,
  tcp_port: 4444,
  web_port: 4040
