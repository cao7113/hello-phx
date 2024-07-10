defmodule HelloPhx.MixProject do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/cao7113/hello-phx"

  def project do
    [
      app: :hello_phx,
      version: @version,
      source_url: @source_url,
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HelloPhx.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  # for handy dev testing
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.2"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      # enable Ecto stats in live_dashboard at /dev/dashboard/ecto_stats?nav=diagnose
      {:ecto_psql_extras, "~> 0.6"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.2"},

      ## Tools
      # {:faker, "~> 0.18", only: :test}
      # also used in HelloPhx.Data
      {:faker, "~> 0.18"},
      {:endon, "~> 2.0"},
      # {:timex, "~> 3.7"},
      {:git_ops, "~> 2.6", only: [:dev], runtime: false},

      ## cluster
      {:libcluster, "~> 3.3"}

      ## Admin
      # https://github.com/aesmail/kaffy
      # {:kaffy, "~> 0.10.2"},
      # {:kaffy, github: "aesmail/kaffy", depth: 1}
      # https://github.com/naymspace/backpex
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "test.reset": ["ecto.drop", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind hello_phx", "esbuild hello_phx"],
      "assets.deploy": [
        "tailwind hello_phx --minify",
        "esbuild hello_phx --minify",
        "phx.digest"
      ],
      "test.demo": &test_demo_task/1
    ]
  end

  def cli do
    [
      preferred_envs: [
        "test.reset": :test,
        "test.demo": :test
      ]
    ]
  end

  def test_demo_task(_args) do
    Mix.shell().info("mix env: #{Mix.env()}")
  end
end
