// Learn more https://docs.expo.io/guides/customizing-metro
const path = require('path');
const {getDefaultConfig} = require('expo/metro-config');
const {
  wrapWithReanimatedMetroConfig,
} = require('react-native-reanimated/metro-config');
const withStorybook = require('@storybook/react-native/metro/withStorybook');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

module.exports = wrapWithReanimatedMetroConfig(
  withStorybook(config, {
    enabled: process.env.WITH_STORYBOOK === 'true',
    configPath: path.resolve(__dirname, './.rnstorybook'),
    onDisabledRemoveStorybook: true,
  }),
);
