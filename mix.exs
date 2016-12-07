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
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kai, []},
      applications: [
        :arc_ecto,
        :phoenix, 
        :phoenix_pubsub, 
        :phoenix_html, 
        :cowboy, 
        :logger, 
        :gettext, 
        :phoenix_slime,
        :phoenix_ecto, 
        :postgrex
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:arc, "~> 0.6.0-rc3"},
      {:arc_ecto, "~> 0.5.0-rc1"},
      {:cowboy, "~> 1.0"},
      {:csv, "~> 1.4.2"},
      {:ex_aws, "~> 1.0.0-rc3"},
      {:exrm, "~> 1.0.8"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.5"},
      {:mailgun, "~> 0.1.2"},
      {:phoenix, "~> 1.2.1"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_slime, "~> 0.8.0"},
      {:poison, "~> 2.1", override: true},
      {:postgrex, ">= 0.0.0"},
      {:secure_random, "~> 0.5"},
      {:sweet_xml, "~> 0.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
