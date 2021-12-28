defmodule WorkflowCmdTest do
  use ExUnit.Case
  #doctest WorkflowCmd

  require Logger
  alias Mix.Tasks.Wf

  test "execute workflow examples" do
    args = ["./examples/workflow1.json", "--verbose"]
    Wf.Run.run(args)
  end
end
