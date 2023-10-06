defmodule Tablerone.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :tablerone,
      deps: deps(),
      dialyzer: dialyzer(),
      docs: docs(),
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [credo: :test, dialyzer: :test],
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  def application,
    do: [
      extra_applications: [:logger]
    ]

  def cli,
    do: [
      preferred_envs: [credo: :test, dialyzer: :test]
    ]

  defp deps,
    do: [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28", only: [:docs, :dev], runtime: false},
      {:mix_audit, "~> 2.0", only: :dev, runtime: false},
      {:moar, "~> 1.10"}
    ]

  defp dialyzer,
    do: [
      plt_add_apps: [:ex_unit, :mix],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]

  defp docs,
    do: []

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end