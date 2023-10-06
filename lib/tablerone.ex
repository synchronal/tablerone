defmodule Tablerone do
  # @related [tests](test/tablerone_test.exs)

  @moduledoc """
  Documentation for `Tablerone`.
  """

  @otp_app Application.compile_env!(:tablerone, :otp_app)

  @doc """
  Renders the given icon as a Phoenix component. If the icon has not been downloaded
  to the priv directory of the parent application, `icon` will raise at run time,
  with instructions on how to run a mix task to download the icon.
  """
  def icon(name) do
    svg_name = Tablerone.dasherize(name)
    svg_path = Path.join([:code.priv_dir(@otp_app), "tablerone", "#{svg_name}.svg"])

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

  def dasherize(icon_name) when is_atom(icon_name), do: dasherize(Atom.to_string(icon_name))
  def dasherize(icon_name) when is_binary(icon_name), do: String.replace(icon_name, "_", "-")
end
