defmodule WorkflowDsl.File do

  require Logger
  alias WorkflowDsl.Storages

  def write(params) do
    Logger.debug("execute :write #{inspect params}")

    parameters = Enum.map(params, fn [k,v] ->
      {k, v}
    end)
    |> Enum.into(%{})

    with true <- Map.has_key?(parameters, "input_var"),
      func <- Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :write}),
      var <- Storages.get_var_by(%{"session" => func.session, "name" => parameters["input_var"]}),
      true <- Map.has_key?(parameters, "output_path"),
      :ok <- File.mkdir_p(Path.dirname(parameters["output_path"])) do
        File.write(parameters["output_path"], :erlang.binary_to_term(var.value))
    end
  end
end
