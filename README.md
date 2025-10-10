# Hello World React Native app

This is an Opinionated React Native template with sensible defaults.

The template was originally developed at [WillowTree](https://github.com/willowtreeapps), and later open sourced.

It is designed to enforce a consistent developer experience for React Native teams of any size.

> [!TIP]
> Before cloning this repo, you should run through the React Native Environment Setup docs for both [iOS](https://reactnative.dev/docs/set-up-your-environment?os=macos&platform=ios) and [Android](https://reactnative.dev/docs/set-up-your-environment?os=macos&platform=android).
>
> Make sure you already have tooling such as Xcode and Android Studio installed.

## Included Features

- based on Expo's [Default template](https://github.com/expo/expo/tree/main/templates/expo-template-default) but additionally includes several additions & customizations
- includes [ESLint](https://eslint.org) + [Prettier](https://prettier.io)
- includes [VSCode](https://code.visualstudio.com) / [Cursor](https://www.cursor.com) extensions
- includes [Jest](https://jestjs.io) + [React Native Testing Library](https://testing-library.com/docs/react-native-testing-library/intro/) for unit testing
- includes [Maestro](https://maestro.mobile.dev) for E2E testing
- includes [Storybook](https://storybook.js.org) for component development
- includes GitHub Action for PR Checks

> [!NOTE]
> This template is set up to use [Continuous Native Generation](https://docs.expo.dev/workflow/continuous-native-generation/).
>
> Please note that it is not compatible with Expo Go.

## Instructions For Organizations

### 🍴 [Fork This Template](https://github.com/jpdriver/react-native-template/fork)

We highly encourage forking this repository to your own GitHub org so you can add organization-specific information to it. This allows your teams to get started as quickly as possible.

For example you could add the following to your forked repo:

```js
// in app.config.js

ios: {
  bundleIdentifier: "com.jpmigueldriver.myapp",
  appleTeamId: "7UMFPW78PV", // <-- add your Team ID
}
```

(see [Apple Team ID docs](https://docs.expo.dev/versions/latest/config/app/#appleteamid))

This will ensure that any new apps made with your fork of the template are pre-configured to use your organization's Apple Team ID, and allows for easy development and testing on physical devices.

Another recommended modification is adding the `owner` field in `app.json` so any created apps will be pre-configured to work with your organization's EAS account.

## Once you have created a project

> [!WARNING]
> Make sure you are using Node >=20.19.4 <23

- delete either `package-lock.json` or `yarn.lock` (see [Package Managers](#package-managers) below)
- find & replace `my-app` with your app name
- find & replace `com.jpmigueldriver.myapp` with your app id
- run `./scripts/init.sh` to install the dependencies
- run `npm run ios` or `npm run android` to start the app
- run `npm start:storybook` to start the storybook UI

### License

Please note that this template is open-source and MIT licensed.
If your project is not open-source, you should:

1. delete the `LICENSE` file
2. remove the `"license"` field from `package.json`
3. add `"private": true` to `package.json`

### Package Managers

> [!IMPORTANT]
> To ensure tested + compatible versions of dependencies are installed, this template includes lock files for both NPM and Yarn.
>
> As one of the first things you do, you should pick which package manager you want to use.

```sh
# if you want to use NPM
rm -rf yarn.lock
./scripts/init.sh
```

```sh
# if you want to use Yarn
rm -rf package-lock.json
./scripts/init.sh
```

### Ruby

This project is intended for use with the version of Ruby that ships with macOS. You should not need to install Ruby separately (e.g. via Homebrew).

However if you would like to use a different version of Ruby, we recommend using [rvm](https://rvm.io/) to manage your Ruby versions.

You may need to update the `.ruby-version` and `Gemfile.lock` files to match the version of Ruby you are using.

### CocoaPods

This project uses Bundler to manage Ruby Gems such as CocoaPods. You should not need to install CocoaPods separately (e.g. via Homebrew).

## (Optional) Steps for further customization

- Adding additional ESLint rules

  - [import/no-default-export](https://github.com/import-js/eslint-plugin-import/blob/main/docs/rules/no-default-export.md)

    - can be desirable to simplify refactoring

      ```sh
      npm install eslint-plugin-import --save-dev
      ```

      ```js
      // in eslintrc.js

      rules: {
        // ...other rules...
        "import/no-default-export": "error", // <-- add the rule
      }
      ```

  - [unused-imports/no-unused-imports](https://github.com/sweepline/eslint-plugin-unused-imports)

    - can automatically remove unused imports

      ```sh
      npm install eslint-plugin-unused-imports --save-dev
      ```

      ```js
      // in eslintrc.js

      rules: {
        // ...other rules...
        "unused-imports/no-unused-imports": "warn", // <-- add the rule
      }
      ```

- Customizing Jest

  - to collect Code Coverage add the following to your `jest.config.js`

    ```js
    "collectCoverage": true,
    "collectCoverageFrom": [
      "**/*.{ts,tsx,js,jsx}",
      "!**/coverage/**",
      "!**/node_modules/**",
      "!**/babel.config.js",
      "!**/expo-env.d.ts",
      "!**/.expo/**"
    ]
    ```

- Add more GitHub workflows

  - if you are using EAS Update you can use the following GitHub Action to show a QR code to scan for iOS and Android
    - [EAS Update GitHub Actions](https://docs.expo.dev/eas-update/github-actions/)

- Add [Husky](https://typicode.github.io/husky/get-started.html) for pre-commit hooks

## Next steps

### Adding Navigation

- [Expo Router](https://expo.dev/router) is the preferred option for adding navigation to new apps.
- However if you prefer to work with fewer dependencies or have other specific needs, another option is [React Navigation](https://reactnavigation.org).

### Configure EAS

- EAS is a suite of tools for building, deploying, and maintaining your app
- see [EAS documentation](https://docs.expo.dev/eas/)

## Notes

- This template is only intended for use with iOS and Android apps.
- `react-native-web` support has been removed
