defmodule WorkflowCmd.Application do
  use Application

  @impl true
  def start(_type, _args) do
    {:ok, self()}
  end
end
