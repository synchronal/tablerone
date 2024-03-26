defmodule Mix.Tasks.Tablerone.Download do
  use Mix.Task

  @shortdoc "Downloads a tabler icon to the local priv directory"
  @moduledoc """
  Downloads a tabler icon to the local priv dir.

      mix tablerone.download --type outline cactus
      mix tablerone.download --type filled cactus cactus-off
  """

  @impl Mix.Task
  def run(args) do
    Mix.Project.get!()
    Mix.Task.run("app.config", args)

    config = Mix.Project.config()
    app = config[:app]
    start([app], :temporary, :serial)
    {opts, icon_names, _} = OptionParser.parse(args, strict: [type: :string], aliases: [t: :type])
    type = Keyword.get(opts, :type)

    if type not in ~w[filled outline] || Enum.empty?(icon_names) do
      usage()
    else
      {:ok, tablerone_dir} = ensure_priv_dir!(app, type)

      for icon_name <- icon_names do
        case __MODULE__.Downloader.get(icon_name, type) do
          {:ok, icon_contents} ->
            Path.join(tablerone_dir, "#{icon_name}.svg")
            |> File.write!(trim_icon(icon_contents))

            Mix.shell().info("Downloaded icon: #{type}/#{icon_name}.svg")

          {:error, error, url} ->
            Mix.raise(error_to_string("Could not download tabler icon #{icon_name} from #{url}", error))
        end
      end
    end
  end

  # # #

  defp error_to_string(msg, error),
    do: msg <> "\n\nError: " <> inspect(error)

  defp could_not_start(app, reason),
    do: "Could not start application #{app}: " <> Application.format_error(reason)

  defp ensure_priv_dir!(app, type) do
    priv_dir = Path.join([:code.priv_dir(app), "tablerone", type])

    case File.mkdir_p(priv_dir) do
      :ok -> {:ok, priv_dir}
      {:error, error} -> Mix.raise("Unable to create tablerone icon directory: #{priv_dir}, error: #{inspect(error)}")
    end
  end

  # copied from https://github.com/elixir-lang/elixir/blob/main/lib/mix/lib/mix/tasks/app.start.ex
  defp start(apps, type, mode) do
    Mix.ensure_application!(:public_key)
    Mix.ensure_application!(:ssl)
    Mix.ensure_application!(:inets)

    case Application.ensure_all_started(apps, type: type, mode: mode) do
      {:ok, _} -> :ok
      {:error, {app, reason}} -> Mix.raise(could_not_start(app, reason))
    end

    :ok
  end

  defp trim_icon(contents) do
    contents
    |> String.replace(~r|<!--.*-->|s, "")
    |> String.trim()
  end

  defp usage do
    IO.puts("USAGE: mix tablerone.download --type <filled | outline> <icon1> [icon2 ...]")
    exit({:shutdown, 1})
  end

  # # #

  defmodule Downloader do
    def get(name, type) do
      headers = [
        {~c"accept", ~c"*/*"},
        {~c"host", ~c"raw.githubusercontent.com"},
        {~c"user-agent", String.to_charlist("erlang-httpc/OTP#{:erlang.system_info(:otp_release)} hex/tablerone")}
      ]

      url = icon_url(name, type)

      case :httpc.request(:get, {url, headers}, [], body_format: :binary) do
        {:ok, {{_, 200, _}, _resp_headers, body}} -> {:ok, to_string(body)}
        {:ok, {{_, 404, _}, _resp_headers, _body}} -> {:error, :not_found, url}
        {:ok, {{_, status_code, _}, _resp_headers, _body}} -> {:error, {:http_error, status_code}, url}
        {:error, error} -> {:error, error, url}
      end
    end

    defp icon_url(name, type),
      do: "https://raw.githubusercontent.com/tabler/tabler-icons/main/icons/#{type}/#{name}.svg"
  end
end
