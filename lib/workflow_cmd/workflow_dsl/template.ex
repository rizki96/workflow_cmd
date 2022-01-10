defmodule WorkflowDsl.Template do

  require Logger
  alias WorkflowDsl.Storages
  alias WorkflowDsl.Lang

  def render(params) do
    Logger.debug("execute :render #{inspect params}")

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :render})
    parameters = Enum.map(params, fn [k,v] ->
      {k, Lang.eval(func.session, v)}
    end)
    |> Enum.into(%{})

    cond do
      Map.has_key?(parameters, "template_string") ->
        result = get_template_result(parameters["template_string"])
        Logger.debug("execute :render result #{inspect result}")
        if Map.has_key?(parameters, "output_path") do
          with :ok <- File.mkdir_p(Path.dirname(parameters["output_path"])) do
            File.write(parameters["output_path"], result)
          end
        end
        {:ok, result}
      Map.has_key?(parameters, "template_path") ->
        tmpl_file = File.read!(parameters["template_path"])
        result = get_template_result(tmpl_file)
        Logger.debug("execute :render result #{inspect result}")
        if Map.has_key?(parameters, "output_path") do
          with :ok <- File.mkdir_p(Path.dirname(parameters["output_path"])) do
            File.write(parameters["output_path"], result)
          end
        end
        {:ok, result}
      Map.has_key?(parameters, "template_url") ->
        if String.starts_with?(parameters["template_url"], ["http://", "https://"]) do
          {:ok, content} = Req.request(:get, parameters["template_url"])
          result = get_template_result(content.body)
          if Map.has_key?(parameters, "output_path") do
            with :ok <- File.mkdir_p(Path.dirname(parameters["output_path"])) do
              File.write(parameters["output_path"], result)
            end
          end
          {:ok, result}
        end
      true -> {:error, nil}
    end
  end

  defp get_template_result(str) do
    {:ok, template} = Solid.parse(str)

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :render})
    vars = Storages.list_vars_by(%{"session" => func.session})
      |> Enum.map(fn it -> {it.name, :erlang.binary_to_term(it.value)} end)
      |> Enum.into(%{})
    result = Solid.render(template, vars) |> to_string
    result
  end

end
