defmodule WorkflowCmdTest do
  use ExUnit.Case
  doctest WorkflowCmd

  test "greets the world" do
    assert WorkflowCmd.hello() == :world
  end
end
