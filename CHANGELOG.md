# Changelog

## Unreleased changes

## 1.0.0

- Require Elixir 1.16 or later.

## 0.5.0

- Verify support for Elixir 1.17.0.

## 0.4.0

*BREAKING CHANGES*
- Tabler Icons has separated its filled icons from its outline icons into different directories (`filled/circle`
  instead of `circle-filled` for example), so Tablerone now stores its icons similarly. Updating to 0.4.0 will
  require moving and renaming a bunch of icons, or just removing all your icons and re-downloading them with
  `mix tablerone.download --type <filled | outline> <icon-name> [<icon-name> ...]`

## 0.3.1

- Fix path to tabler icons

## 0.3.0

- Download icons from github.com instead of from tabler.io.
- Improve error message when an icon can't be downloaded.

## 0.2.1

- Fix bug where sometimes an icon filename wouldn't get dasherized.

## 0.2.0

- `Tablerone.icon` and `Tablerone.path` can take strings, and can get `:otp_app` from opts.
- Add `Tablerone.path/1` for introspecting the local priv path of svg files.
- `mix tablerone.download` ensures erlang dependencies are started, sets user agent.

## 0.1.0

Initial release.

- `Tablerone.icon` function loads file from parent application's priv dir.
- `mix tablerone.download <icon>` mix task.
