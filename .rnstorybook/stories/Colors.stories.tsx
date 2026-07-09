import type { Meta, StoryObj } from '@storybook/react-native';
import { ColorList } from './ColorList';

const meta = {
  title: 'Theme',
  component: ColorList,
} satisfies Meta<typeof ColorList>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Colors: Story = {
  args: {},
};
