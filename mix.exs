defmodule Kai.Mixfile do
  use Mix.Project

  def project do
    [app: :kai,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_client_env: [espec: :test],
     aliases: aliases(),
     deps: deps()]
  end

  def application do
    [ mod: {Kai, []},
      applications: app_list(Mix.env) ]
  end

  def app_list do
    [
      :phoenix, 
      :phoenix_ecto, 
      :phoenix_html, 
      :phoenix_pubsub, 
      :phoenix_slime,
      :bamboo,
      :cowboy, 
      :std_json_io,
      :gherkin,

      :logger, 
      :number,
      :porcelain,
      :gettext, 
      :postgrex,
      :arc_ecto,
      :ex_aws,
      :httpoison,
      :timex
    ]
  end

  def app_list(:test), do: [:hound | app_list]
  def app_list(_),     do: app_list

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix
      {:phoenix, "~> 1.2.1"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_slime, "~> 0.8.0"},

      # Model helpers
      {:ecto_autoslug_field, "~> 0.2"},
      {:ex_admin, "~> 0.8"},
      {:number, "~> 0.5.0"},

      # Amazon image hosting
      {:arc, "~> 0.6.0-rc3"},
      {:arc_ecto, "~> 0.5.0-rc1"},
      {:ex_aws, "~> 1.0.0-rc3"},
      {:httpoison, "~> 0.7"}, 

      # deloyment
      {:distillery, "1.0.0"},
      # Testing
      {:ex_machina, "~> 1.0", only: [:test]},
      {:cabbage, github: "mgwidmann/cabbage", only: [:dev, :test]},
      #      {:white_bread, "~> 2.5", only: [:dev, :test]},
      {:hound, "~> 1.0"},
      {:gherkin, "~> 0.1.0", github: "mgwidmann/gherkin"},

      # Linting
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev], runtime: false},
      {:dialyze, "~> 0.2.0"},

      # Networks
      {:porcelain, "~> 2.0"},
      {:exredis, ">= 0.1.1"},
      {:toniq, "~> 1.0"},

      {:cowboy, "~> 1.0"},
      {:csv, "~> 1.4.2"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.5"},
      {:hashids, "~> 2.0"},
      {:bamboo, github: "thoughtbot/bamboo"},
      {:poison, "~> 2.1", override: true},
      {:postgrex, ">= 0.0.0"},
      {:secure_random, "~> 0.5"},
      {:sweet_xml, "~> 0.5"},
      {:std_json_io, "~> 0.1.0"},
      {:timex, "~> 3.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": [
        "ecto.create", 
        "ecto.migrate", 
        "run priv/repo/seeds.exs"
      ],
    "ecto.reset": ["ecto.drop", "ecto.setup"],
    "test": ["ecto.create --quiet", "ecto.migrate", "test"]
  ]
  end
end
