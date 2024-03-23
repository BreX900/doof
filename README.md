# mek_gasol

- Run web app: `--web-renderer html`
- Run web server: `--web-renderer html -d web-server --web-hostname 0.0.0.0 --web-port 8080`
- Generate assets: `dart pub global run mek_assets build`

> `--web-renderer html` is necessary because web app cant download image without it

## Firebase

See: https://firebase.google.com/docs/flutter/setup

- `dart pub global activate flutterfire_cli`
- `flutterfire configure --out=lib/packages/firebase_options.dart --android-app-id=mek.gasol.mek_gasol`

## Flutter

### Providers (riverpod)

- `ref.onDisposeInvalidate([provider, ...])`: Invalidate parents when current provider is invalidated
- `ref.watch(UsersProviders.currentId)`: Refresh provider when user is changed 
