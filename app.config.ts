import { ConfigContext, ExpoConfig } from 'expo/config';

export default ({ config }: ConfigContext): ExpoConfig => {
  config.extra = config.extra || {};
  config.extra.isStorybook = process.env.STORYBOOK_ENABLED === 'true';
  return config as ExpoConfig;
};
