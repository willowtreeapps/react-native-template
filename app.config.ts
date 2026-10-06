import { ExpoConfig } from 'expo/config';
import appJson from './app.json';

function getName() {
  const base = appJson.expo.name;

  switch (process.env.APP_VARIANT) {
    case 'production':
      return base;
    case 'preview':
      return `${base} (Preview)`;
    default:
      return `${base} (Dev)`;
  }
}

function getAppId(platform: 'ios' | 'android') {
  const base =
    platform === 'ios'
      ? appJson.expo.ios.bundleIdentifier
      : appJson.expo.android.package;

  switch (process.env.APP_VARIANT) {
    case 'production':
      return base;
    case 'preview':
      return `${base}.preview`;
    default:
      return `${base}.dev`;
  }
}

export default ({ config }: { config: typeof appJson.expo }): ExpoConfig => {
  config.name = getName();

  config.ios.bundleIdentifier = getAppId('ios');
  config.android.package = getAppId('android');

  config.extra.isStorybook = process.env.STORYBOOK_ENABLED === 'true';

  return config as ExpoConfig;
};
