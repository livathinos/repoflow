defmodule Repoflow.Mixfile do
  use Mix.Project

  def project do
    [app: :repoflow,
     version: "0.0.1",
     name: "Repoflow",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:httpotion]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:httpotion, github: "myfreeweb/httpotion"},
      {:jsx, github: "talentdeficit/jsx"},
      {:ex_doc, github: "elixir-lang/ex_doc"},
      {:earmark, "~> 0.1.0"}
    ]
  end

  def escript_config do
    [ main_module: Repoflow.CLI ]
  end
end
