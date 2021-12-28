defmodule WorkflowDsl.Template do

  require Logger

  def render(params) do
    Logger.debug("execute :render #{inspect params}")
  end
end
