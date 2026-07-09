import { FlashList, FlashListProps } from '@shopify/flash-list';
import { StyleSheet, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

function ItemSeparator() {
  return <View style={styles.itemSeparator} />;
}

export function ThemedList<T>(props: FlashListProps<T>) {
  const safeAreaInsets = useSafeAreaInsets();

  const contentContainerStyle = StyleSheet.flatten([
    {
      paddingLeft: safeAreaInsets.left + 20,
      paddingRight: safeAreaInsets.right + 20,
    },
    props.contentContainerStyle,
  ]);

  return (
    <FlashList
      contentInsetAdjustmentBehavior="automatic"
      ItemSeparatorComponent={ItemSeparator}
      {...props}
      contentContainerStyle={contentContainerStyle}
    />
  );
}

const styles = StyleSheet.create({
  itemSeparator: {
    height: 20,
  },
});
