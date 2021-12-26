defmodule WorkflowCmd do
  use Bakeware.Script

  alias Mix.Tasks.Wf

  @impl Bakeware.Script
  def main([]) do
    IO.puts("\nRunning the JSON workflow DSL via command-line
\nCommand: workflow_cmd <json workflow file path / URL> [--verbose]
")
  end

  def main(args) do
    Wf.Run.run(args)
    0
  end
end
