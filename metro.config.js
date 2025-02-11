// Learn more https://docs.expo.io/guides/customizing-metro
const path = require('path');
const {getDefaultConfig} = require('expo/metro-config');
const withStorybook = require('@storybook/react-native/metro/withStorybook');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

module.exports = withStorybook(config, {
  enabled: process.env.WITH_STORYBOOK === 'true',
  configPath: path.resolve(__dirname, './.storybook'),
  onDisabledRemoveStorybook: true,
});
