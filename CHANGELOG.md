# Changelog

## Unreleased changes

- Add `Tablerone.path/1` for introspecting the local priv path of svg files.
- `mix tablerone.download` ensures erlang dependencies are started, sets user agent.

## 0.1.0

Initial release.

- `Tablerone.icon` function loads file from parent application's priv dir.
- `mix tablerone.download <icon>` mix task.

