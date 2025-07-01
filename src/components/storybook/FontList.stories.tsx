import type {Meta, StoryObj} from '@storybook/react';
import {StyleSheet, View} from 'react-native';
import {FontList} from './FontList';

const meta = {
  title: 'Theme',
  component: FontList,
  decorators: [
    Story => (
      <View style={styles.storyWrapper}>
        <Story />
      </View>
    ),
  ],
} satisfies Meta<typeof FontList>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Fonts: Story = {};

const styles = StyleSheet.create({
  storyWrapper: {
    padding: 16,
    alignItems: 'flex-start',
  },
});
