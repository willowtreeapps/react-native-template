module.exports = ({config}) => {
  const withStorybook = process.env.WITH_STORYBOOK;

  return {
    ...config,
    extra: {
      ...config.extra,
      withStorybook,
    },
  };
};
