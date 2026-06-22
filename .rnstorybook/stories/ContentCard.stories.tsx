import type { Meta, StoryObj } from '@storybook/react-native';
import { ContentCard } from '../../src/components/ContentCard';

const meta = {
  title: 'ContentCard',
  component: ContentCard,
} satisfies Meta<typeof ContentCard>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Basic: Story = {
  args: {
    item: 'Sample Item',
  },
};
