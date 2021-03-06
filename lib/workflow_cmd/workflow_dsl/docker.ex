defmodule WorkflowDsl.Docker do

  require Logger
  alias WorkflowDsl.Storages
  alias WorkflowDsl.Lang

  @one_minute 60_000
  @default_tag "latest"

  def create(params) do
    Logger.debug("execute :create #{inspect params}")
    load_version()

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :create})
    parameters = Enum.map(params, fn [k,v] ->
      {k, Lang.eval(func.session, v)}
    end)
    |> Enum.into(%{})

    auth =
    if Map.has_key?(parameters, "credentials") do
      Enum.map(parameters["credentials"], fn [k,v] -> {k,v} end)
        |> Enum.into(%{})
    end

    hostname =
      if Map.has_key?(parameters, "hostname"), do: parameters["hostname"], else: ""

    command =
      if Map.has_key?(parameters, "command"), do: parameters["command"], else: ""

    entrypoint =
      if Map.has_key?(parameters, "entrypoint"), do: parameters["entrypoint"], else: ""

    image =
      if Map.has_key?(parameters, "image"), do: parameters["image"]

    tag =
      if Map.has_key?(parameters, "tag"), do: parameters["tag"], else: @default_tag

    env =
      if Map.has_key?(parameters, "env"), do: parameters["env"], else: %{}

    volumes =
      if Map.has_key?(parameters, "volumes"), do: parameters["volumes"], else: %{}

    ports =
      if Map.has_key?(parameters, "exposed_ports"), do: parameters["exposed_ports"], else: %{}

    conf = create_config(%{
      "image" => image,
      "tag" => tag,
      "auth" => auth,
      "hostname" => hostname,
      "command" => command,
      "entrypoint" => entrypoint,
      "env" => env,
      "ports" => ports,
      "volumes" => volumes
    })

    created =
    with true <- Map.has_key?(parameters, "name") do
      create_container(conf, parameters["name"])
    else
      _ ->
        create_container(conf)
    end
    # waiting for container to be created
    Logger.debug("created #{inspect created}")

    with %{"Id" => id} <- created do
      Logger.debug("created id: #{inspect id}")
      {:ok, id}
    else
      %{"message" => msg} ->
        case Regex.named_captures(~r/container \"(?<id>.+)\"/, msg) do
          %{"id" => id} ->
            Logger.debug("created id: #{inspect id}")
            {:ok, id}
          _ -> {:error, nil}
        end
    end
  end

  def start(params) do
    Logger.debug("execute :start #{inspect params}")

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :start})
    parameters = Enum.map(params, fn [k,v] ->
      {k, Lang.eval(func.session, v)}
    end)
    |> Enum.into(%{})

    result =
    with true <- Map.has_key?(parameters, "id") do
      start_container(parameters["id"])
    end
    Logger.debug("execute :start result: #{inspect result}")
  end

  def create_start(params) do
    Logger.debug("execute :create_start #{inspect params}")
  end

  def destroy(params) do
    Logger.debug("execute :destroy #{inspect params}")

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :destroy})
    parameters = Enum.map(params, fn [k,v] ->
      {k, Lang.eval(func.session, v)}
    end)
    |> Enum.into(%{})

    result =
    with true <- Map.has_key?(parameters, "id"),
      true <- Map.has_key?(parameters, "image"),
      true <- Map.has_key?(parameters, "tag") do
        delete_container(parameters["id"],
          parameters["image"] <> ":" <> parameters["tag"])
    else
      _ ->
        with true <- Map.has_key?(parameters, "id"),
          true <- Map.has_key?(parameters, "image") do
            delete_container(parameters["id"], parameters["image"] <> ":latest")
        else
          _ ->
            with true <- Map.has_key?(parameters, "id") do
              delete_container(parameters["id"])
            end
        end
    end
    Logger.debug("execute :destroy result: #{inspect result}")
  end

  def compose(params) do
    Logger.debug("execute :compose #{inspect params}")

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :compose})
    parameters = Enum.map(params, fn [k,v] ->
      {k, Lang.eval(func.session, v)}
    end)
    |> Enum.into(%{})

    config =
      with true <- Map.has_key?(parameters, "config_path") do
        parameters["config_path"]
      else
        _ ->
          with true <- Map.has_key?(parameters, "config_url") do
            if String.starts_with?(parameters["config_url"], ["http://", "https://"]) do
              {:ok, content} = Req.request(method: :get, url: parameters["config_url"])
              File.write!(Path.basename(parameters["config_url"]), content.body)
              Path.basename(parameters["config_url"])
            else
              Path.basename(parameters["config_url"])
            end
          else
            _ -> "docker-compose.yml"
          end
      end

    command =
      with true <- Map.has_key?(parameters, "command") do
        parameters["command"]
      else
        _ -> ""
      end

    name =
      with true <- Map.has_key?(parameters, "project_name") do
        parameters["project_name"]
      else
        _ -> ""
      end

    services =
      with true <- Map.has_key?(parameters, "service") do
        Enum.map(eval_args(parameters["service"], :compose), fn it ->
          {:service, it}
        end)
      else
        _ -> []
      end |> Enum.into([])

    # Logger.log(:debug, "#{inspect func.module}, #{inspect command}, #{inspect [name: name, compose_path: config] ++ services}")
    result = apply(String.to_existing_atom("Elixir.DockerCompose"), String.to_existing_atom(command), [[project_name: name, compose_path: config] ++ services])
    Logger.log(:debug, "#{inspect result}")
  end

  def logs(params) do
    Logger.debug("execute :logs #{inspect params}")

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :logs})
    parameters = Enum.map(params, fn [k,v] ->
      {k, Lang.eval(func.session, v)}
    end)
    |> Enum.into(%{})

    format =
    with true <- Map.has_key?(parameters, "format") do
      parameters["format"]
    else
      _ -> "raw"
    end

    result =
    with true <- Map.has_key?(parameters, "id") do
      with true <- Map.has_key?(parameters, "stdout"),
        true <- Map.has_key?(parameters, "stderr") do
        logs_container(parameters["id"],
          %{"stdout" => parameters["stdout"],
          "stderr" => parameters["stderr"],
          "format" => format})
      else
        _ ->
          with true <- Map.has_key?(parameters, "stdout") do
            logs_container(parameters["id"],
            %{"stdout" => parameters["stdout"],
            "stderr" => true,
            "format" => format})
          else
            _ ->
              logs_container(parameters["id"],
              %{"stdout" => true,
              "stderr" => true,
              "format" => format})
            end
          with true <- Map.has_key?(parameters, "stderr") do
            logs_container(parameters["id"],
            %{"stdout" => true,
            "stderr" => parameters["stderr"],
            "format" => format})
          else
            _ ->
              logs_container(parameters["id"],
              %{"stdout" => true,
              "stderr" => true,
              "format" => format})
            end
      end
    end
    result =
    case format do
      "map" ->
        %{
          "stdout" =>
            result
            |> Enum.filter(fn {typ, _, _} -> typ == "stdout" end)
            |> Enum.map(fn {_, _, content} -> content end)
            |> Enum.join(""),
          "stderr" =>
            result
            |> Enum.filter(fn {typ, _, _} -> typ == "stderr" end)
            |> Enum.map(fn {_, _, content} -> content end)
            |> Enum.join("")
        }
      "info" ->
        result
        |> Enum.map(fn {typ, _, content} -> "[#{typ}] " <> content end)
        |> Enum.join("")
      _ ->
        result
        |> Enum.map(fn {_, _, content} -> content end)
        |> Enum.join("")
    end
    Logger.debug("execute :logs result: #{inspect result}")
    {:ok, result}
  end

  def create_start_destroy(params) do
    Logger.debug("execute :create_start_destroy #{inspect params}")
  end

  defp create_config(%{
    "image" => image,
    "tag" => tag,
    "auth" => auth,
    "hostname" => hostname,
    "command" => command,
    "entrypoint" => entrypoint,
    "env" => env,
    "ports" => ports,
    "volumes" => volumes
  } = _params) do
    with false <- is_nil(image) do
      with false <- is_nil(tag),
      false <- is_nil(auth) do
        result = pull_image(image, tag, auth)
        Logger.log(:debug, "pull_image: #{inspect result}")

        %Docker.Config{
          generic_hostname: (if not is_nil(hostname), do: true, else: false),
          hostname: hostname,
          command: command,
          entrypoint: entrypoint,
          image: image <> ":" <> tag,
          environment: env,
          ports: ports,
          volumes: volumes
        }
        |> Docker.Config.create_container
      else
        _ ->
          result = pull_image(image, tag)
          Logger.log(:debug, "pull_image: #{inspect result}")

          %Docker.Config{
            generic_hostname: (if not is_nil(hostname), do: true, else: false),
            hostname: hostname,
            command: command,
            image: image <> ":" <> tag,
            environment: env,
            ports: ports,
            volumes: volumes
          }
          |> Docker.Config.create_container
      end
    end
  end

  defp pull_image(image, tag, auth) do
    auth_header = auth |> Jason.encode!() |> Base.encode64()
    headers = [{"x-registry-auth", auth_header}]

    #Docker.Images.pull(image, tag, auth)
    case "/images/create"
    |> Docker.Client.post("",
      headers: headers,
      query: %{fromImage: image, tag: tag},
      opts: [adapter: [recv_timeout: @one_minute]]
      ) do
      %{"message" => msg} ->
        msg
        |> String.split("\r\n")
        |> Enum.filter(&(&1 != ""))
      other ->
        other
        |> String.split("\r\n")
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(fn stat -> stat |> Jason.decode!() end)
    end
  end
  defp pull_image(image, tag) do
    #Docker.Images.pull(image, "latest", auth)
    case "/images/create"
    |> Docker.Client.post("",
      query: %{fromImage: image, tag: tag},
      opts: [adapter: [recv_timeout: @one_minute]]
      ) do
      %{"message" => msg} ->
        msg
        |> String.split("\r\n")
        |> Enum.filter(&(&1 != ""))
      other ->
        other
        |> String.split("\r\n")
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(fn stat -> stat |> Jason.decode!() end)
    end
  end

  defp create_container(conf, name) do
    Docker.Containers.create(conf, name)
  end
  defp create_container(conf) do
    Docker.Containers.create(conf)
  end

  defp start_container(id) do
    # Docker.Containers.start(id)
    Docker.Client.post("/containers/#{id}/start", %{},
      opts: [adapter: [recv_timeout: @one_minute]])
  end

  defp delete_container(id, image) do
    delete_container(id)
    Docker.Images.delete(image)
  end
  defp delete_container(id) do
    Docker.Containers.stop(id)
    Docker.Containers.remove(id)
  end

  defp logs_container(id, %{"stdout" => stdout, "stderr" => stderr, "format" => format}) do
    if format == "raw" do
      {content, _} = System.cmd("docker", ["logs", "#{id}"], into: "", stderr_to_stdout: true)
      [{"stdout", 0, content}, {"stderr", 0, ""}]
    else
      "/containers/#{id}/logs?stdout=#{stdout}&stderr=#{stderr}&tail=100"
      |> Docker.Client.get()
      |> logs_parser(0)
    end
  end

  defp logs_parser(str, begin) do
    case str do
      nil -> [{"stdout", 0, ""}, {"stderr", 0, ""}]
      "" -> [{"stdout", 0, ""}, {"stderr", 0, ""}]
      _ ->
        log_typ =
          case binary_part(str, begin + 0, 1) do
            <<1>> -> "stdout"
            <<2>> -> "stderr"
          end

        len = :binary.decode_unsigned(binary_part(str, begin + 4, 4))
        content = binary_part(str, begin + 8, len)
        #Logger.debug("content: #{inspect content}")
        if (begin + len + 8) < String.length(str) do
          [{log_typ, len, "#{content}"}] ++ logs_parser(str, begin + len + 8)
        else
          [{log_typ, len, "#{content}"}]
        end
    end
  end

  defp load_version() do
    {docker_cmd, 0} = System.cmd("docker", ["version", "-f", "json"])
    docker_info = docker_cmd |> Jason.decode!()
    #Logger.log(:debug, "#{inspect docker_info}")
    Application.put_env(:docker, :version, "v" <> docker_info["Client"]["DefaultAPIVersion"])
    docker_host =
    case :os.type() do
      {:unix, _} -> "unix:///var/run/docker.sock"
      {:win32, _} -> "tcp://127.0.0.1:2375"
    end
    Application.put_env(:docker, :host, docker_host)
  end

  defp eval_args(param, func_name) do
    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => func_name})
    cond do
      is_list(param) -> Enum.map(
        param, fn to ->
          Lang.eval(func.session, to)
        end)
      true -> [param]
    end
  end
end
