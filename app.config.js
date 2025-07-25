module.exports = ({config}) => {
  const withStorybook = process.env.WITH_STORYBOOK;
  const enableProxyman = process.env.ENABLE_PROXYMAN === 'true';

  return {
    ...config,
    plugins: enableProxyman
      ? config.plugins.concat('expo-android-proxyman')
      : config.plugins,
    extra: {
      ...config.extra,
      withStorybook,
    },
  };
};
