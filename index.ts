import {registerRootComponent} from 'expo';
import {LogBox} from 'react-native';

import App from './src/App';
import {isTest} from './src/utils/isTest';

if (isTest) {
  // LogBox can interfere with Maestro tests so we disable it
  LogBox.ignoreAllLogs();
}

// registerRootComponent calls AppRegistry.registerComponent('main', () => App);
// It also ensures that whether you load the app in Expo Go or in a native build,
// the environment is set up appropriately
registerRootComponent(App);
