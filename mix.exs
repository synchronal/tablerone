defmodule Tablerone.MixProject do
  use Mix.Project

  @scm_url "https://github.com/synchronal/tablerone"
  @version "0.3.0"

  def project do
    [
      app: :tablerone,
      deps: deps(),
      description: "Download load tabler icons to and load from the current project",
      dialyzer: dialyzer(),
      docs: docs(),
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      homepage_url: @scm_url,
      package: package(),
      preferred_cli_env: [credo: :test, dialyzer: :test],
      source_url: @scm_url,
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
      plt_add_apps: [:ex_unit, :inets, :mix],
      plt_add_deps: :app_tree,
      plt_core_path: "_build/#{Mix.env()}"
    ]

  defp docs,
    do: []

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package,
    do: [
      licenses: ["MIT"],
      maintainers: ["synchronal.dev", "Erik Hanson", "Eric Saxby"],
      links: %{"GitHub" => @scm_url}
    ]
end
