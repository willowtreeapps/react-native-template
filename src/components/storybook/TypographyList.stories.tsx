import type {Meta, StoryObj} from '@storybook/react';
import {StyleSheet, View} from 'react-native';
import {TypographyList} from './TypographyList';

const meta = {
  title: 'Theme',
  component: TypographyList,
  decorators: [
    Story => (
      <View style={styles.storyWrapper}>
        <Story />
      </View>
    ),
  ],
} satisfies Meta<typeof TypographyList>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Typography: Story = {
  args: {
    text: '',
  },
};

const styles = StyleSheet.create({
  storyWrapper: {
    padding: 16,
    alignItems: 'flex-start',
  },
});
