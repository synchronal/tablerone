defmodule Tablerone do
  # @related [tests](test/tablerone_test.exs)

  @moduledoc """
  Documentation for `Tablerone`.
  """

  @otp_app Application.compile_env(:tablerone, :otp_app)
  @priv_dir :code.priv_dir(@otp_app)

  @doc """
  Renders the given icon as a Phoenix component. If the icon has not been downloaded
  to the priv directory of the parent application, `icon` will raise at compile time,
  with instructions on how to run a mix task to download the icon.
  """
  defmacro icon(name) do
    svg_name = Tablerone.dasherize(name)
    svg_path = Path.join([@priv_dir, "tablerone", "#{svg_name}.svg"])

    svg_contents =
      if File.exists?(svg_path) do
        File.read!(svg_path)
      else
        :elixir_errors.erl_warn(__ENV__.line, __ENV__.file, """
        Icon :#{name} has not been downloaded.

        To download this icon to the local application, run the following in a terminal:

            mix tablerone.download #{svg_name}
        """)

        nil
      end

    quote do
      unquote(svg_contents)
    end
  end

  def dasherize(icon_name) when is_atom(icon_name), do: dasherize(Atom.to_string(icon_name))
  def dasherize(icon_name) when is_binary(icon_name), do: String.replace(icon_name, "_", "-")
end
