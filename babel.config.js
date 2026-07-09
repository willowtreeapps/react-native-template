module.exports = function (api) {
  api.cache(true);

  const presets = ['babel-preset-expo'];
  const plugins = ['react-native-worklets/plugin'];

  if (process.env.NODE_ENV === 'production') {
    plugins.unshift('transform-remove-console');
  }

  return {
    presets,
    plugins,
  };
};
