Run the project's prebuild and native setup.

## Steps

1. Ask the user which platform they want to target: `ios`, `android`, or `both` (default).
2. Run the appropriate script based on their answer:

**Both platforms (default):**
```bash
./scripts/prebuild.sh
```

**iOS only:**
```bash
./scripts/prebuild.sh --platform ios
```

**Android only:**
```bash
./scripts/prebuild.sh --platform android
```

3. If the user has not run `./scripts/install-dependencies.sh` yet (i.e., `node_modules` is missing), run it first:
```bash
./scripts/install-dependencies.sh
```

4. After prebuild completes, confirm the native directories were generated:
   - iOS: check that `ios/Podfile.lock` exists
   - Android: check that `android/build.gradle` exists

5. Report success and remind the user of available run commands:
   - `yarn ios` — run on iOS device
   - `yarn android` — run on Android device
   - `yarn start` — start Metro bundler only

## Notes

- `prebuild.sh` reads `app.json` to determine which platforms are enabled
- CocoaPods installation is handled inside `prebuild.sh` via `bundle exec pod install`
- If `vendor/` is missing, `bundle install` will run automatically
- For a full clean setup from scratch, use `./scripts/init.sh` instead
