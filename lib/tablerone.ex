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
    svg_path = Path.join([@priv_dir, "tablerone", "#{name}.svg"])

    svg_contents =
      if File.exists?(svg_path) do
        File.read!(svg_path)
      else
        :elixir_errors.erl_warn(__ENV__.line, __ENV__.file, "Icon :#{name} has not been downloaded.")
        nil
      end

    quote do
      unquote(svg_contents)
    end
  end
end
