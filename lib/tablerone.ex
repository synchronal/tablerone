defmodule Tablerone do
  # @related [tests](test/tablerone_test.exs)

  @moduledoc """
  Tablerone is a library for downloading specific tabler icons to the local application,
  and then rendering them from the file system.

  ## Installation

  Tablerone must be configured to know the parent application, in `config/config.exs`:

  ```elixir
  import Config

  # ...existing config

  config :tablerone, :otp_app, <:my_app>
  ```

  ## Usage

  When using new icons, they can be downloaded using the provided mix task:

  ```shell
  mix tablerone.download <icon-name> <icon-name>
  ```

  To load an icon in a heex component, the following example code may be used:

  ```elixir
  attr :name, :atom, required: true
  attr :class, :any, default: []

  def icon(assigns) do
    name = assigns[:name]
    icon_contents = Tablerone.icon(name)

    assigns =
      assign_new(assigns, :icon_contents, fn ->
        class = [class: assigns[:class]] |> Phoenix.HTML.attributes_escape() |> Phoenix.HTML.safe_to_string()
        String.replace(icon_contents, ~r{class="[^"]+"}, class)
      end)

    ~H\"""
    <%= Phoenix.HTML.raw(@icon_contents) %>
    \"""
  end
  ```
  """

  @otp_app Application.compile_env!(:tablerone, :otp_app)

  @doc """
  Renders the given icon as a Phoenix component. If the icon has not been downloaded
  to the priv directory of the parent application, `icon` will raise at run time,
  with instructions on how to run a mix task to download the icon.

  ## Examples

      iex> icon = Tablerone.icon(:cactus_off)
      iex> match?("<svg " <> _, icon)
      true
  """
  def icon(name) when is_atom(name) do
    svg_name = Tablerone.dasherize(name)
    svg_path = Tablerone.path(name)

    if File.exists?(svg_path) do
      File.read!(svg_path)
    else
      raise ArgumentError, """
      Icon :#{name} has not been downloaded.

      To download this icon to the local application, run the following in a terminal:

          mix tablerone.download #{svg_name}
      """
    end
  end

  @doc """
  Given an icon as a string or atom, returns the expected path to the svg file.

  The file is saved to a `tablerone` director in the priv dir of the parent application,
  specified by the `:tablerone, :otp_app` config.
  """
  def path(icon_name) when is_atom(icon_name), do: icon_name |> dasherize() |> path()

  def path(icon_name) when is_binary(icon_name) do
    Path.join([:code.priv_dir(@otp_app), "tablerone", "#{icon_name}.svg"])
  end

  @doc false
  def dasherize(icon_name) when is_atom(icon_name), do: dasherize(Atom.to_string(icon_name))
  def dasherize(icon_name) when is_binary(icon_name), do: String.replace(icon_name, "_", "-")
end
