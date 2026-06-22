import { LogBox } from 'react-native';
import { isTest } from './src/utils/isTest';

// Import side effects first and services
if (isTest) {
  // LogBox can interfere with Maestro tests so we disable it
  LogBox.ignoreAllLogs();
}

// Initialize services

// Register app entry through Expo Router
import 'expo-router/entry';
