defmodule WorkflowDsl.File do

  require Logger

  def write(params) do
    Logger.debug("execute :write #{inspect params}")
  end
end
