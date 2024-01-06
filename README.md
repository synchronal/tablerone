# Tablerone

Renders [Tabler Icons](https://tabler.io/icons) by downloading individual icons to the priv directory of the parent
application during development, and loading them from files at runtime.

## Installation

```elixir
def deps do
  [
    {:tablerone, "~> 0.2"}
  ]
end
```

## Usage

Configure tablerone with the `:otp_app` of the parent application, so that icons can be
loaded from the proper priv directory at run time.

```elixir
import Config

config :tablerone, :otp_app, <:my_app>
```

Run the mix task to download one or more icons.


```shell
mix tablerone.download <icon-name> <icon-name-2> ...
```

An example heex component for rendering the icon.


```elixir
attr :name, :atom, required: true
attr :class, :list, default: []

defp icon(assigns) do
  name = assigns[:name]
  icon_contents = Tablerone.icon(name)

  assigns =
    assign_new(assigns, :icon_contents, fn ->
      class = [class: assigns[:class]] |> Phoenix.HTML.attributes_escape() |> Phoenix.HTML.safe_to_string()
      String.replace(icon_contents, ~r{class="[^"]+"}, class)
    end)

  ~H"""
  <%= Phoenix.HTML.raw(@icon_contents) %>
  """
end
```
