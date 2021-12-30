defmodule WorkflowDsl.Docker do

  require Logger

  def create(params) do
    Logger.debug("execute :create #{inspect params}")

  end

  def run(params) do
    Logger.debug("execute :run #{inspect params}")

  end
end
