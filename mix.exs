defmodule WorkflowCmd.MixProject do
  use Mix.Project
  @app :workflow_cmd
  @version "0.4.0"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_env: [release: :prod]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: (if Mix.env() == :test or Mix.env() == :dev, do: {WorkflowCmd.Application, []}, else: {WorkflowCmd, []})
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:workflow_dsl, git: "https://github.com/rizki96/workflow_dsl.git"},
      {:solid, "~> 0.10"},
      {:docker, "~> 0.4.0"},
      {:docker_compose, "~> 0.3"},
      {:bakeware, "~> 0.2.2", runtime: false}
    ]
  end

  defp aliases do
    [
      "release.mac": ["cmd rm -fr _build", "cmd mix release", "cmd tar czvf #{@app}-#{@version}.tar.gz -C _build/prod/rel/bakeware/ #{@app}"],
      "release.win": ["cmd rd /s /q _build", "cmd mix release"], # TODO: release.win
    ]
  end

  defp release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      quiet: true,
      steps: [:assemble, &Bakeware.assemble/1],
      strip_beams: Mix.env() == :prod
    ]
  end
end
