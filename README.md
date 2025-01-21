# Development Guidance

[internal readme](http://go/genui-panel-readme)

## Extension

All commands are for the directory `extension`

### Rebuild packages

```
npm install
```

### Start web

```
python3 -m http.server 50001 --directory assets/web
```

### Rebuild code

```
npm install
npm run compile
```

### Run locally

1. If you want to use local UI:
    a. Temporarily update config.ts to have isLocal = true
    d. Run UI via one of options:
        * In Run and Debug select `ui` and run (or press F5)
        * Run `flutter run -d chrome --web-port=8080`

2. To start recompilation on changes run:

    ```
    npm run watch
    ```

3. In Run and Debug select `extension` and run (or press F5)

### Test in IDX

1. Create vsix file:

    NOTE: before compiling and sharing the build do not forget to:
    * switch 'local' to false in [config.ts](extension/src/shared/config.ts)
    * `firebase deploy` ui

    ```
    vsce package --allow-missing-repository
    ```

2. Open the tab "Extensions" in an IDX project.
3. Drag and drop vsix file to IDX folder.

### Read logs

In IDX: chrome console (open it with Chrome > menu > more tools > developer tools)
In host vscode: debug console (select 'right' thing at top right)
In child vscode: command Open Webview Developer Tools

## UI

All commands here are for the directory `ui`.

Basic commands:
```
flutter build web
flutter run -d chrome --web-port=8080
flutter run -d web-server --web-port=8080
flutter run -d web-server --web-port=8080 --release
```

### Deploy to Firebase

Demo version is hosted on polina's account: https://genui-panel.web.app/

To deploy ask @polinach to make you contributor.

IMPORTANT: switch to Flutter stable, because it is what firebase supports.

Run:

```
firebase deploy
```

### Authentication in Google

Using:
* https://pub.dev/packages/google_sign_in
* https://pub.dev/packages/google_sign_in_web
* To generate client ID: https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid

See internal details in http://go/genui-panel-readme

## TODO before releasing

1. Handle runtime errors
2. Write readme for extension
3. Cleanup dead code and test cover live code
4. Dispose and shut down what is created and started
