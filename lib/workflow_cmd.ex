defmodule WorkflowCmd do
  use Bakeware.Script

  alias Mix.Tasks.Wf

  @impl Bakeware.Script
  def main([]) do
    IO.puts("\nRunning the JSON workflow DSL via command-line
worflow_cmd ver. #{Application.spec(:workflow_cmd, :vsn)}
\nCommand: workflow_cmd <json workflow file path / URL> [--verbose] [--execute subworkflow-name] [--json-args json-body]
\n    script file path / URL     : json formatted script that will be executed
    --verbose                  : display debug information
    --execute subworkflow-name : execute specific subworkflow name that exists in script
    --json-args json-body      : add input parameters for subworkflow in json format
\nEx.: > workflow_cmd https://raw.githubusercontent.com/rizki96/workflow_dsl/master/examples/workflow3.json --verbose
")
  end

  def main(args) do
    Wf.Run.run(args)
    0
  end
end
