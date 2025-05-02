# Tablerone

Renders [Tabler Icons](https://tabler.io/icons) by downloading individual icons to the priv directory of the parent
application during development, and loading them from files at runtime.

This library is tested against the latest 3 versions of Elixir.

## Sponsorship 💕

This library is part of the [Synchronal suite of libraries and tools](https://github.com/synchronal)
which includes more than 15 open source Elixir libraries as well as some Rust libraries and tools.

You can support our open source work by [sponsoring us](https://github.com/sponsors/reflective-dev).
If you have specific features in mind, bugs you'd like fixed, or new libraries you'd like to see,
file an issue or contact us at [contact@reflective.dev](mailto:contact@reflective.dev).

## Installation

```elixir
def deps do
  [
    {:tablerone, "~> 1.0"}
  ]
end
```

## Usage

In `config.exs`, configure tablerone with the `:otp_app` of the parent application, so that icons can be
loaded from the proper priv directory at run time.

```elixir
import Config

config :tablerone, :otp_app, <:my_app>
```

Run the mix task to download one or more icons.


```shell
mix tablerone.download --type <filled | outline> <icon-name> <icon-name-2> ...
```

An example heex component for rendering the icon.


```elixir
attr :name, :atom, required: true
attr :type, :atom, required: true, values: [:filled, :outline]
attr :class, :list, default: []

defp icon(assigns) do
  name = assigns[:name]
  type = assigns[:type]

  icon_contents = Tablerone.icon(name, type)

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
