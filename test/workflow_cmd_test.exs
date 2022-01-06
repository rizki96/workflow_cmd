defmodule WorkflowCmdTest do
  use ExUnit.Case
  doctest WorkflowCmd

  require Logger
  alias Mix.Tasks.Wf

  test "execute workflow examples" do
    for n <- 1..2 do
      args = ["./examples/workflow#{n}.json", "--verbose"]
      Wf.Run.run(args)
    end
  end
end
