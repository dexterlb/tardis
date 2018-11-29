use Mix.Config

config :potoo_server,
  root_target: :potoo_global_registry,
  dev_proxy: true,
  tcp_port: 4444,
  web_port: 4040
