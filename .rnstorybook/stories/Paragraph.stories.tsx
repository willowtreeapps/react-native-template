import type { Meta, StoryObj } from '@storybook/react-native';
import { Paragraph } from '../../src/components/Paragraph';

const meta = {
  title: 'Paragraph',
  component: Paragraph,
} satisfies Meta<typeof Paragraph>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Basic: Story = {
  args: {
    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse facilisis lacus vel libero finibus, vitae feugiat justo ultrices. Sed elementum nisl in lectus commodo, eu vestibulum erat egestas.',
  },
};
