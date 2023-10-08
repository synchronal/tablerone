defmodule Mix.Tasks.Tablerone.Download do
  use Mix.Task

  @shortdoc "Downloads a tabler icon to the local priv directory"
  @moduledoc """
  Downloads a tabler icon to the local priv dir.

      mix tablerone.download cactus
      mix tablerone.download cactus cactus-off
  """

  @impl Mix.Task
  def run(args) do
    Mix.Project.get!()
    Mix.Task.run("app.config", args)

    config = Mix.Project.config()
    app = config[:app]
    start([app], :temporary, :serial)
    {:ok, tablerone_dir} = ensure_priv_dir!(app)

    {_opts, icon_names, _} = OptionParser.parse(args, switches: [])

    for icon_name <- icon_names do
      case __MODULE__.Downloader.get(icon_name) do
        {:ok, icon_contents} ->
          Path.join(tablerone_dir, "#{icon_name}.svg")
          |> File.write!(String.trim(icon_contents))

          Mix.shell().info("Downloaded icon: #{icon_name}.svg")

        {:error, error} ->
          Mix.raise(error_to_string("Could not download tabler icon #{icon_name}", error))
      end
    end
  end

  # # #

  defp error_to_string(msg, error),
    do: msg <> "\n\nError: " <> inspect(error)

  defp could_not_start(app, reason),
    do: "Could not start application #{app}: " <> Application.format_error(reason)

  defp ensure_priv_dir!(app) do
    priv_dir = :code.priv_dir(app) |> Path.join("tablerone")

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

  # # #

  defmodule Downloader do
    def get(name) do
      headers = [
        {~c"accept", ~c"*/*"},
        {~c"host", ~c"tabler-icons.io"},
        {~c"user-agent", String.to_charlist("erlang-httpc/OTP#{:erlang.system_info(:otp_release)} hex/tablerone")}
      ]

      case :httpc.request(:get, {icon_url(name), headers}, [], body_format: :binary) do
        {:ok, {{_, 200, _}, _resp_headers, body}} -> {:ok, to_string(body)}
        {:ok, {{_, 404, _}, _resp_headers, _body}} -> {:error, :not_found}
        {:ok, {{_, status_code, _}, _resp_headers, _body}} -> {:error, {:http_error, status_code}}
        {:error, error} -> {:error, error}
      end
    end

    defp icon_url(name),
      do: "https://tabler-icons.io/static/tabler-icons/icons/#{name}.svg"
  end
end
