# Changelog

## Unreleased changes

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

