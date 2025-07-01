import {Colors, Theme} from './types';

export const theme: Record<'light' | 'dark', Theme> = {
  light: {
    backgroundColor: Colors.white,
    textColor: Colors.black,
  },
  dark: {
    backgroundColor: Colors.black,
    textColor: Colors.white,
  },
};
