import { LaunchArguments } from 'react-native-launch-arguments';

export function isE2ETest() {
  try {
    const isE2E = LaunchArguments.value().isE2E;
    return !!isE2E;
  } catch {
    return false;
  }
}

export const isTest = process.env.NODE_ENV === 'test' || isE2ETest();
