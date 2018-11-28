defmodule Control.MixProject do
  use Mix.Project

  def project do
    [
      app: :control,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :server, :global_registry, :mqtt_mesh],
      mod: {Control.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    if Mix.env == :prod do
      [
        {:potoo_global_registry, git: "https://github.com/DexterLB/potoo.git", sparse: "potoo_global_registry", runtime: false},
        {:potoo_mqtt,            git: "https://github.com/DexterLB/potoo.git", sparse: "potoo_mqtt",            runtime: false},
        {:potoo_server,          git: "https://github.com/DexterLB/potoo.git", sparse: "potoo_server",          runtime: false},
        {:potoo,                 git: "https://github.com/DexterLB/potoo.git", sparse: "potoo",                 runtime: false, override: true},
      ]
    else
      [
        {:potoo_global_registry, "../../../potoo", sparse: "potoo_global_registry", runtime: false},
        {:potoo_mqtt,            "../../../potoo", sparse: "potoo_mqtt",            runtime: false},
        {:potoo_server,          "../../../potoo", sparse: "potoo_server",          runtime: false},
        {:potoo,                 "../../../potoo", sparse: "potoo",                 runtime: false, override: true},
      ]
    end ++
    [


      {:distillery, "~> 2.0"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
