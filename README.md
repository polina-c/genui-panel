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

Then one of:
1. Open [extension.ts](extension/src/extension.ts) and press F5
2. Run and Debug > Run Extension

### Test in IDX

1. Create vsix file:

    ```
    vsce package --allow-missing-repository
    ```

2. Open the tab "Extensions" in an IDX project.
3. Drag and drop vsix file to IDX folder.

## UI

All commands are for the directory `ui`.

```
flutter build web
flutter run -d chrome --web-port=50000
```

## TODO before releasing

1. What if hard coded port is occupied?
2. Write readme for extension
3. Cleanup and test cover
