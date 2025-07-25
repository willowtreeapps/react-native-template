module.exports = function (api) {
  api.cache(true);

  const presets = ['babel-preset-expo'];
  const plugins = ['react-native-reanimated/plugin'];

  if (process.env.NODE_ENV === 'production') {
    // react-native-reanimated/plugin must be the last plugin
    plugins.unshift('transform-remove-console');
  }

  return {
    presets,
    plugins,
  };
};
