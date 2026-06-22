import type { Preview } from '@storybook/react-native';
import { StatusBar } from 'expo-status-bar';

const preview: Preview = {
  decorators: [
    Story => (
      <>
        <StatusBar style="auto" />
        <Story />
      </>
    ),
  ],
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/,
      },
    },
  },
};

export default preview;
