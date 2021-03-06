defmodule EventStore.Mixfile do
  use Mix.Project

  def project do
    [
      app: :event_store,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {EventStore.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:couchbeam, git: "https://github.com/benoitc/couchbeam.git"},
      { :uuid, "~> 1.1" }
    ]
  end
end
