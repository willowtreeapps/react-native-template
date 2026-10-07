# TELUS Digital React Native Template

The recommended starting point for new React Native apps at [TELUS Digital](https://github.com/willowtreeapps). It's an opinionated [Expo](https://expo.dev) project with sensible defaults, so every team starts with the same tooling, conventions and quality gates.

> [!TIP]
> New to React Native? Work through the environment setup guides for [iOS](https://reactnative.dev/docs/set-up-your-environment?os=macos&platform=ios) and [Android](https://reactnative.dev/docs/set-up-your-environment?os=macos&platform=android) before you start. You need Xcode and Android Studio installed.

## Quick start

### 1. Check your toolchain

| Tool                    | Version                    | Notes                                                                                                   |
| ----------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------- |
| macOS                   | –                          | iOS builds require a Mac                                                                                |
| Node                    | `>=22.22.1`                | Use a version manager such as [nvm](https://github.com/nvm-sh/nvm)                                      |
| Yarn ⭐ **Recommended** | `1.22.x`                   | The supported package manager (over npm). Provided by Corepack, see [Package manager](#package-manager) |
| Ruby                    | `.ruby-version` (`3.2.11`) | Use [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/)                                   |
| Xcode                   | `>=26.4`                   | Install an iOS simulator runtime too                                                                    |
| Android Studio          | latest                     | With an Android SDK and an emulator                                                                     |
| CocoaPods               | –                          | Don't install it yourself. Bundler installs it from the `Gemfile`                                       |

`yarn install` runs `scripts/check-tool-versions.sh` first and stops with a clear message if Node, Ruby or Xcode is too old.

### 2. Create your project

1. On GitHub, click **Use this template** to create a new repository, then clone it.
2. Find & replace `my-app` / `My App` with your app's slug and display name.
3. Find & replace `com.willowtreeapps.myapp` with your app id (in `app.json` and `.maestro/home.yml`). Maestro flows target the development variant, so keep the `.dev` suffix in `.maestro/` (see [App variants](#app-variants)).
4. If your project is not open source, [update the license](#license).

### 3. Install and run

```sh
./scripts/init.sh   # clean, install dependencies, generate ios/ and android/, install pods
yarn ios            # build and install the development build on an iOS device or simulator
yarn android        # same for Android
```

The first build takes a while. After that, `yarn start` is usually all you need, see [Development builds](#development-builds).

## What's included

### Platform

- **[Expo SDK 57](https://docs.expo.dev/versions/v57.0.0/) with React Native 0.86** and React 19. The New Architecture is on by default.
- **[React Compiler](https://react.dev/learn/react-compiler)** is enabled (`experiments.reactCompiler`), so you rarely need manual `useMemo` / `useCallback`.
- **iOS and Android only.** Web is intentionally unsupported ([ADR 0004](docs/adr/0004-why-we-dont-support-web.md)).
- **TypeScript** everywhere, including typed Expo Router routes.

### Development builds and Continuous Native Generation

This template uses [**`expo-dev-client`**](https://docs.expo.dev/develop/development-builds/introduction/) instead of Expo Go. A development build is your own app binary with the Expo developer tools built in, so it can include any native module and config plugin. Expo Go can't, so **this template doesn't work in Expo Go**.

The `ios/` and `android/` folders are generated from `app.json`, `app.config.ts` and config plugins using [Continuous Native Generation](https://docs.expo.dev/workflow/continuous-native-generation/) (`expo prebuild`). They're git-ignored, so don't edit them by hand ([ADR 0003](docs/adr/0003-why-we-use-cng.md)). Change config or add a config plugin instead.

| You changed…                                                               | Do this                                                           |
| -------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| JS / TS code                                                               | Nothing. Metro reloads it in the running dev build                |
| A package with native code, `app.json`, `app.config.ts` or a config plugin | `./scripts/prebuild.sh --clean`, then `yarn ios` / `yarn android` |

### App variants

`app.config.ts` derives the app name and id from the `APP_VARIANT` environment variable, so different builds can be installed side by side:

| `APP_VARIANT`         | App name         | App id                             |
| --------------------- | ---------------- | ---------------------------------- |
| unset / `development` | My App (Dev)     | `com.willowtreeapps.myapp.dev`     |
| `preview`             | My App (Preview) | `com.willowtreeapps.myapp.preview` |
| `production`          | My App           | `com.willowtreeapps.myapp`         |

Switch with `./scripts/switch-variant.sh <development|preview|production>`, which regenerates the native projects.

iOS signing uses TELUS Digital's Apple Team ID (`appleTeamId` in `app.json`), and `owner` is set to the `willowtreeapps` EAS account. Update both if your project uses a client's team or account.

### Libraries

| Area                 | Library                                                                                                                                                                                                                                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Navigation           | [Expo Router](https://docs.expo.dev/router/introduction/), file-based routes in `src/app/` ([ADR 0006](docs/adr/0006-why-we-use-expo-router.md))                                                                                                                         |
| Data fetching        | [TanStack Query](https://tanstack.com/query), with the cache persisted to [AsyncStorage](https://react-native-async-storage.github.io/async-storage/) ([ADR 0007](docs/adr/0007-why-we-use-react-query.md))                                                              |
| Lists                | [FlashList](https://shopify.github.io/flash-list/)                                                                                                                                                                                                                       |
| Animation            | [Reanimated](https://docs.swmansion.com/react-native-reanimated/), [Worklets](https://docs.swmansion.com/react-native-worklets/), [Gesture Handler](https://docs.swmansion.com/react-native-gesture-handler/)                                                            |
| UI                   | [Bottom Sheet](https://gorhom.dev/react-native-bottom-sheet/), [expo-image](https://docs.expo.dev/versions/v57.0.0/sdk/image/), [react-native-svg](https://github.com/software-mansion/react-native-svg) (import `.svg` files directly), DateTimePicker, Slider, WebView |
| Dates                | [date-fns](https://date-fns.org)                                                                                                                                                                                                                                         |
| Open source licenses | [react-native-legal](https://github.com/callstackincubator/react-native-legal) generates the third-party license screens for both platforms                                                                                                                              |
| Native config        | `expo-build-properties` (Android `minSdkVersion` 33), `expo-splash-screen`, `expo-system-ui`, `expo-font`                                                                                                                                                                |

### Code quality

- **ESLint** (React Native config plus Jest, Testing Library, TanStack Query and unused-import rules) and **Prettier**. Disabling `react-hooks/exhaustive-deps` is blocked.
- **Husky** pre-commit hook runs `yarn lint`, `yarn format` and `yarn tsc --noEmit`.
- **GitHub Actions** "PR Checks" workflow runs lint, format check, tests, TypeScript and an iOS JS bundle export on every pull request. Native builds aren't run in CI ([ADR 0008](docs/adr/0008-why-we-dont-use-github-actions-to-build.md)).
- **VS Code / Cursor** recommended extensions and settings in `.vscode/`.

### Testing and component development

- **Unit tests:** [Jest](https://jestjs.io) with [React Native Testing Library](https://callstack.github.io/react-native-testing-library/) ([ADR 0009](docs/adr/0009-how-we-test.md)). Shared helpers are in `src/utils/TestUtils.tsx`.
- **E2E tests:** [Maestro](https://maestro.mobile.dev) flows in `.maestro/`. They target the development variant (`.dev` app id) that `yarn ios` / `yarn android` install. Flows launch the app with an `isE2E` [launch argument](https://github.com/iamolegga/react-native-launch-arguments), which turns off LogBox.
- **Storybook:** [Storybook for React Native](https://github.com/storybookjs/react-native) with stories in `.rnstorybook/stories/`. `yarn start:storybook` serves Storybook in place of the app inside your dev build.
- **React Query DevTools:** in development, press `shift + m` in the Expo CLI to open the [`@dev-plugins/react-query`](https://github.com/expo/dev-plugins) inspector.

### AI agents

The template is set up for agentic development with [Claude Code](https://claude.com/product/claude-code), [Codex](https://openai.com/codex/) and GitHub Copilot ([ADR 0005](docs/adr/0005-why-we-include-expo-skills-and-mcp.md)):

- `AGENTS.md` holds project rules for agents. `CLAUDE.md` is a symlink to it, and `.github/copilot-instructions.md` covers Copilot.
- [Expo Skills](https://expo.dev/expo-skills) are vendored in `.agents/skills/` and pinned in `skills-lock.json`.
- MCP servers for [Expo](https://docs.expo.dev/mcp/), Figma and GitHub are configured in `.mcp.json` (Claude Code) and `.codex/config.toml` (Codex).

## Everyday commands

| Command                | What it does                                                                 |
| ---------------------- | ---------------------------------------------------------------------------- |
| `yarn start`           | Start Metro for an already-installed dev build                               |
| `yarn ios`             | Build and run on an iOS device or simulator (you'll be prompted to pick one) |
| `yarn android`         | Build and run on an Android device or emulator                               |
| `yarn start:storybook` | Start Metro with Storybook instead of the app                                |
| `yarn test`            | Run Jest unit tests                                                          |
| `yarn test:e2e`        | Run Maestro flows against the installed app                                  |
| `yarn lint`            | Run ESLint on `src/`                                                         |
| `yarn format`          | Format everything with Prettier                                              |
| `yarn tsc --noEmit`    | Type-check the project                                                       |

### Scripts

| Script                            | What it does                                                                               |
| --------------------------------- | ------------------------------------------------------------------------------------------ |
| `scripts/init.sh`                 | Full reset: clean, install dependencies, prebuild both platforms                           |
| `scripts/prebuild.sh`             | Regenerate native projects and install pods. Options: `--platform ios\|android`, `--clean` |
| `scripts/switch-variant.sh`       | Clean prebuild for a given [app variant](#app-variants)                                    |
| `scripts/clean.sh`                | Delete `node_modules`, `vendor`, `.expo`, `ios/` and `android/`                            |
| `scripts/upgrade-dependencies.sh` | Upgrade Expo and all dependencies to the latest compatible versions                        |
| `scripts/upgrade-skills.sh`       | Update the vendored Expo Skills                                                            |
| `scripts/check-tool-versions.sh`  | Check Node, Ruby and Xcode versions (runs automatically before `yarn install`)             |
| `scripts/compile-plugins.sh`      | Compile local Expo modules and config plugins in `modules/`, if you add any                |

## Project structure

```text
src/
  app/             Expo Router routes and layouts (file-based routing)
  components/      Shared UI components and their tests
  hooks/           Custom hooks, e.g. data fetching with TanStack Query
  theme/           Theme tokens and colors
  utils/           Runtime helpers and test utilities
  AppProviders.tsx Root providers (React Query, navigation theme, safe area, gesture handler)
.maestro/          Maestro E2E flows
.rnstorybook/      Storybook config and stories
assets/            App icons, splash screen and images
docs/adr/          Architecture Decision Records: why the template is built this way
scripts/           Setup, build and maintenance scripts
app.json           Static Expo config (name, ids, plugins)
app.config.ts      Dynamic Expo config (app variants, Storybook flag)
```

## Toolchain details

### Package manager

This template uses Yarn (v1) and ships a single `yarn.lock` with tested, compatible dependency versions ([ADR 0010](docs/adr/0010-why-we-use-yarn.md)). The exact version is pinned via the `packageManager` field in `package.json`, and `./scripts/init.sh` enables it through [Corepack](https://nodejs.org/api/corepack.html), so there's no need to install Yarn globally.

```sh
# if `yarn` is not on your PATH
corepack enable yarn
```

> [!NOTE]
> You can still switch your project to npm if you prefer. Without `yarn.lock`, npm resolves fresh versions within the ranges in `package.json`, so you lose the tested lock file. Some current peer dependency ranges also require `legacy-peer-deps`.
>
> ```sh
> rm yarn.lock
> echo "legacy-peer-deps=true" > .npmrc
> corepack use npm   # updates `packageManager` and generates package-lock.json
> ./scripts/init.sh
> ```
>
> Then replace `yarn` commands with their npm equivalents in `.husky/pre-commit` and `.github/workflows/PR Checks.yml` (`cache: npm`, `cache-dependency-path: package-lock.json`, `npm install`, `npm run …`, `npx …`).

For Expo and React Native packages, always use `npx expo install <package>` so you get the version that matches the SDK.

### Ruby and CocoaPods

Ruby is pinned in `.ruby-version`, and CocoaPods is installed per project through Bundler and the `Gemfile` ([ADR 0002](docs/adr/0002-why-we-use-bundler.md)). You don't need a global CocoaPods install. If you have to use a different Ruby version, update `.ruby-version` and `Gemfile.lock` to match.

## Troubleshooting

- **`pod install` fails with "CocoaPods could not find compatible versions" after upgrading dependencies.** `ios/Podfile.lock` is stale. Run `./scripts/prebuild.sh --clean`.
- **`npx expo-doctor` reports "Failed to find dependency tree … npm explain".** Corepack blocks `npm` in a Yarn project, and expo-doctor uses it internally. Run `COREPACK_ENABLE_STRICT=0 npx expo-doctor`.
- **The dev build can't connect to Metro.** Make sure `yarn start` is running and the device is on the same network as your Mac. If you changed native config, rebuild with `yarn ios` / `yarn android`.
- **Something is badly out of sync.** `./scripts/init.sh` resets dependencies and native projects from scratch.

## License

This template is MIT licensed. Most projects built from it aren't open source, so you should:

1. delete the `LICENSE` file
2. remove the `"license"` field from `package.json`
3. add `"private": true` to `package.json`

## Next steps

- **Set up EAS** to build, submit and update your app: see the [EAS documentation](https://docs.expo.dev/eas/). If you use EAS Update, the [EAS Update GitHub Action](https://docs.expo.dev/eas-update/github-actions/) can post QR codes on pull requests.
- **Collect code coverage** by adding this to `jest.config.js`:

  ```js
  collectCoverage: true,
  collectCoverageFrom: [
    '**/*.{ts,tsx,js,jsx}',
    '!**/coverage/**',
    '!**/node_modules/**',
    '!**/babel.config.js',
    '!**/expo-env.d.ts',
    '!**/.expo/**',
  ],
  ```

## Maintaining this template

This repository is TELUS Digital's fork of [jpdriver/react-native-template](https://github.com/jpdriver/react-native-template). To pull in upstream updates, **merge** the upstream branch (don't squash or re-apply it) so future merges stay conflict-free. Keep these TELUS Digital-specific changes when resolving conflicts:

- `app.json`: `owner`, `ios.appleTeamId`, and the `com.willowtreeapps.myapp` app id
- The extra Expo Skills in `skills-lock.json` and the local `create-adr` skill
- This README and ADR 0010
