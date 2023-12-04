defmodule Marker.MixProject do
  use Mix.Project

  def project do
    [
      app: :marker,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      default_release: :marker
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Marker.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon, :debugger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # need phoenix_view dependency for kaffy to work.
      # it throws `module Phoenix.View is not loaded and could not be found` otherwise.
      # https://elixirforum.com/t/module-phoenix-view-is-not-loaded-and-could-not-be-found/52362/2
      {:phoenix_view, "~> 2.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:phoenix, "~> 1.7.3"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:heroicons, "~> 0.5.3"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.2", runtime: Mix.env() == :dev},
      {:finch, "~> 0.13"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:temp, "~> 0.4"},
      {:styler, "~> 0.7", only: [:dev, :test], runtime: false}
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
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
