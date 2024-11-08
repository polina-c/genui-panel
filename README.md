# Development Guidance

[tech notes](https://docs.google.com/document/d/1ReI23IcRr65cPxu3L4jx5tVqfvmoI2EAOHaucKnkVkg/edit?tab=t.0#heading=h.ijy48vijd9j0)

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
npm run compile
```

### Run locally

1. To start recompilation on changes run:

* For hosted UI:
`npm run watch`

* For local UI:
`npm run watch-local-ui`

2. In Run and Debug select `extension` and run (or press F5)

### Test in IDX

1. Create vsix file:

    ```
    vsce package --allow-missing-repository
    ```

2. Open the tab "Extensions" in an IDX project.
3. Drag and drop vsix file to IDX folder.

### Read logs

In IDX: chrome console (open it with Chrome > menu > more tools > developer tools)
In host vscode: debug console
In child vscode: command Open Webview Developer Tools

### Recreate flutter app

IMPORTANT: switch to flutter stable to get support in IDX

```
flutter create ui  --platforms=web
```

## UI

All commands here are for the directory `ui`.

```
flutter build web
flutter run -d chrome --web-port=50000
```

### Deploy to Firebase

Demo version is hosted on polina's account: https://genui-panel.web.app/

To deploy ask @polinach to give you permissions or to run:

```
firebase deploy
```

### Re-add web

```
flutter create --platforms=web .
```

## TODO before releasing

1. Handle runtime errors
2. Write readme for extension
3. Cleanup dead code and test cover live code
4. Dispose and shut down what is created and started
