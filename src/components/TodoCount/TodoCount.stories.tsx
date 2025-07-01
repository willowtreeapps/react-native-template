import {StyleSheet, View} from 'react-native';
import type {Meta, StoryObj} from '@storybook/react';
import {TodoCount} from './TodoCount';

const meta = {
  title: 'TodoCount',
  component: TodoCount,
  decorators: [
    Story => (
      <View style={styles.storyWrapper}>
        <Story />
      </View>
    ),
  ],
} satisfies Meta<typeof TodoCount>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Basic: Story = {};

const styles = StyleSheet.create({
  storyWrapper: {
    padding: 16,
    alignItems: 'flex-start',
  },
});
