module.exports = function (api) {
  api.cache(true);
  return {
    presets: [
      'babel-preset-expo',
      'transform-remove-console',
      'react-native-reanimated/plugin',
    ],
  };
};
