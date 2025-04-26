# Hello World React Native app

This is Telus Digital's recommended template to use when starting a new React Native app.

> [!TIP]
> Before cloning this repo, you should run through the React Native Environment Setup docs for both [iOS](https://reactnative.dev/docs/set-up-your-environment?os=macos&platform=ios) and [Android](https://reactnative.dev/docs/set-up-your-environment?os=macos&platform=android).
>
> Make sure you already have tooling such as Xcode and Android Studio installed.

## Included Features

- originally based on Expo's [Blank (Typescript) template](https://github.com/expo/expo/tree/main/templates/expo-template-blank-typescript)
- includes [ESLint](https://eslint.org) + [Prettier](https://prettier.io)
- includes [VSCode](https://code.visualstudio.com) / [Cursor](https://www.cursor.com) extensions
- includes [Jest](https://jestjs.io) + [React Native Testing Library](https://testing-library.com/docs/react-native-testing-library/intro/) for unit testing
- includes [Maestro](https://maestro.mobile.dev) for E2E testing
- includes [Storybook](https://storybook.js.org) for component development
- includes GitHub Action for PR Checks

> [!NOTE]
> This template is set up to use [Continuous Native Generation](https://docs.expo.dev/workflow/continuous-native-generation/)

## Getting started

> [!WARNING]
> Make sure you are using Node < 23

- find & replace `my-app` with your app name
- find & replace `com.jpmigueldriver.myapp` with your app id
- run `npm install` to install the dependencies
- run `npm run ios` or `npm run android` to start the app
- run `npm start:storybook` to start the storybook UI

### Package Managers

> [!IMPORTANT]
> To ensure tested + compatible versions of dependencies are installed, this template includes lock files for both NPM and Yarn.
>
> As one of the first things you do, you should pick which package manager you want to use.

```sh
# if you want to use NPM
rm -rf node_modules yarn.lock
npm install
```

```sh
# if you want to use Yarn
rm -rf node_modules package-lock.json
yarn install
```

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

You have several options for adding navigation to your app:

- [React Navigation](https://reactnavigation.org)
- [Expo Router](https://expo.dev/router)

### Add Apple Team ID

- You should add the following to your `app.config.js`
  - see [Apple Team ID docs](https://docs.expo.dev/versions/latest/config/app/#appleteamid)
  - see [here](https://willowtree.atlassian.net/wiki/spaces/PD/pages/3056861513/WillowTree-Owned+Developer+Accounts) for a list of our internal Apple Teams you may wish to use

```js
ios: {
  bundleIdentifier: "com.jpmigueldriver.myapp",
  appleTeamId: "7UMFPW78PV", // <-- add your Team ID
}
```

### Configure EAS

- EAS is a suite of tools for building, deploying, and maintaining your app
- see [EAS documentation](https://docs.expo.dev/eas/)

## Notes

- `react-native-web` support has been removed
  - see [this link](https://willowtree.atlassian.net/wiki/spaces/SD/pages/2732916827/React+Native+Web) for more
