defmodule WorkflowDsl.Mailer do
  use Swoosh.Mailer, otp_app: :worfklow_cmd

  @default_prefix "Elixir.Swoosh.Adapters"

  alias WorkflowDsl.Lang
  alias WorkflowDsl.Storages
  import Swoosh.Email

  require Logger

  def send(params) do

    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :send})
    parameters = Enum.map(params, fn [k,v] ->
      {k, Lang.eval(func.session, v)}
    end)
    |> Enum.into(%{})

    adapter =
      if Map.has_key?(parameters, "adapter"),
        do: String.to_existing_atom(@default_prefix <> "." <> parameters["adapter"]),
        else: String.to_existing_atom(@default_prefix <> "." <> "Local")

    config = create_context(adapter, parameters)
    config = Swoosh.Mailer.parse_config(:workflow_cmd, __MODULE__, config, [])

    email = create_email(parameters)
    Swoosh.Mailer.deliver(email, config)
  end

  defp create_context(Elixir.Swoosh.Adapters.SMTP = adapter, parameters) do
    relay =
      with true <- Map.has_key?(parameters, "relay") do
        parameters["relay"]
      else
        _ -> ""
      end

    username =
      with true <- Map.has_key?(parameters, "username") do
        parameters["username"]
      else
        _ -> ""
      end

    password =
      with true <- Map.has_key?(parameters, "password") do
        parameters["password"]
      else
        _ -> ""
      end

    port =
      with true <- Map.has_key?(parameters, "port") do
        parameters["port"]
      else
        _ -> 0
      end

    ssl =
      with true <- Map.has_key?(parameters, "ssl") do
        parameters["ssl"]
      else
        _ -> true
      end

    tls =
      with true <- Map.has_key?(parameters, "tls") do
        String.to_existing_atom(parameters["tls"])
      else
        _ -> :always
      end

    auth =
      with true <- Map.has_key?(parameters, "auth") do
        String.to_existing_atom(parameters["auth"])
      else
        _ -> :always
      end

    no_mx_lookups =
      with true <- Map.has_key?(parameters, "no_mx_lookups") do
        parameters["no_mx_lookups"]
      else
        _ -> false
      end

    retries =
      with true <- Map.has_key?(parameters, "retries") do
        parameters["retries"]
      else
        _ -> 0
      end

    [
      adapter: adapter,
      relay: relay,
      username: username,
      password: password,
      port: port,
      tls: tls,
      ssl: ssl,
      auth: auth,
      no_mx_lookups: no_mx_lookups,
      retries: retries
    ]
  end

  defp create_context(_adapter, _parameters) do
    # using local adapter
    %{
      adapter: Elixir.Swoosh.Adapters.Local
    }
  end

  defp create_email(parameters) do
    subject =
      with true <- Map.has_key?(parameters, "subject") do
        parameters["subject"]
      else
        _ -> ""
      end

    from =
      with true <- Map.has_key?(parameters, "from") do
        parameters["from"]
      else
        _ -> ""
      end

    to =
      with true <- Map.has_key?(parameters, "to") do
        eval_args(parameters["to"])
      else
        _ -> []
      end

    cc =
      with true <- Map.has_key?(parameters, "cc") do
        eval_args(parameters["cc"])
      else
        _ -> []
      end

    bcc =
      with true <- Map.has_key?(parameters, "bcc") do
        eval_args(parameters["bcc"])
      else
        _ -> []
      end

    text =
      with true <- Map.has_key?(parameters, "text") do
        parameters["text"]
      else
        _ -> ""
      end

    html =
      with true <- Map.has_key?(parameters, "html") do
        parameters["html"]
      else
        _ -> ""
      end

    files =
      with true <- Map.has_key?(parameters, "attachments") do
        eval_args(parameters["attachments"])
      else
        _ -> []
      end

    attachments = fn mail, attaches ->
      Enum.reduce(attaches, nil, fn att, acc ->
        # check if att http or local
        {file_path, file_type} =
        if String.starts_with?(att, ["http://", "https://"]) do
          {:ok, content} = Req.request(:get, att)
          File.write!(Path.basename(att), content.body)
          {Path.basename(att), MIME.from_path(Path.basename(att))}
        else
          {att, MIME.from_path(att)}
        end

        Logger.log(:debug, "#{inspect file_path}, #{inspect file_type}")

        case acc do
          nil ->
            attachment(mail, Swoosh.Attachment.new(
              {:data, File.read!(file_path)},
              filename: Path.basename(file_path),
              type: :inline,
              content_type: file_type
            ))
          m ->
            attachment(m, Swoosh.Attachment.new(
              {:data, File.read!(file_path)},
              filename: Path.basename(file_path),
              type: :inline,
              content_type: file_type
            ))
        end
      end)
    end

    new()
    |> subject(subject)
    |> from(from)
    |> to(to)
    |> cc(cc)
    |> bcc(bcc)
    |> text_body(text)
    |> html_body(html)
    |> attachments.(files)
  end

  defp eval_args(param) do
    func = Storages.get_last_function_by(%{"module" => __MODULE__, "name" => :send})
    cond do
      is_list(param) -> Enum.map(
        param, fn to ->
          Lang.eval(func.session, to)
        end)
      true -> [param]
    end
  end


end
