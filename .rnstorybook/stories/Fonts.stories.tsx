import type { Meta, StoryObj } from '@storybook/react-native';
import { FontList } from './FontList';

const meta = {
  title: 'Theme',
  component: FontList,
} satisfies Meta<typeof FontList>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Fonts: Story = {
  args: {
    text: '',
  },
};
