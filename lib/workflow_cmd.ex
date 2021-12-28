defmodule WorkflowCmd do
  use Bakeware.Script
  # use Application

  alias Mix.Tasks.Wf

  @impl Bakeware.Script
  def main([]) do
    IO.puts("\nRunning the JSON workflow DSL via command-line
\nCommand: workflow_cmd <json workflow file path / URL> [--verbose]
Ex.: > workflow_cmd https://raw.githubusercontent.com/rizki96/workflow_dsl/master/examples/workflow3.json --verbose
")
  end

  def main(args) do
    Wf.Run.run(args)
    0
  end

  # @impl true
  # def start(_type, _args) do
  #   {:ok, self()}
  # end
end
