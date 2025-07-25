import type {Meta, StoryObj} from '@storybook/react';
import {StyleSheet, View} from 'react-native';
import {ColorList} from './ColorList';

const meta = {
  title: 'Theme',
  component: ColorList,
  decorators: [
    Story => (
      <View style={styles.storyWrapper}>
        <Story />
      </View>
    ),
  ],
} satisfies Meta<typeof ColorList>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Colors: Story = {};

const styles = StyleSheet.create({
  storyWrapper: {
    padding: 16,
    alignItems: 'flex-start',
  },
});
