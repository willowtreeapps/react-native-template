import {LaunchArguments} from 'react-native-launch-arguments';

export const isE2ETest = () => {
  try {
    const isE2E = LaunchArguments.value().isE2E;
    return !!isE2E;
  } catch (e) {
    return false;
  }
};

export const isTest = process.env.NODE_ENV === 'test' || isE2ETest();
