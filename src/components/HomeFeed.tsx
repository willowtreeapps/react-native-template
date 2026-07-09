import { ActivityIndicator, StyleSheet } from 'react-native';
import { useHomeQuery } from '../hooks/useHomeQuery';
import { ContentCard } from './ContentCard';
import { ThemedList } from './ThemedList';
import { ThemedText } from './ThemedText';

function renderItem({ item }: { item: string }) {
  return <ContentCard item={item} />;
}

export function HomeFeed() {
  const { data, isError, isLoading } = useHomeQuery();

  let emptyComponent = (
    <ThemedText style={styles.emptyText}>No items found.</ThemedText>
  );

  if (isLoading) {
    emptyComponent = (
      <ActivityIndicator size="large" testID="loading-indicator" />
    );
  } else if (isError) {
    emptyComponent = (
      <ThemedText style={styles.emptyText}>An error occurred.</ThemedText>
    );
  }

  return (
    <ThemedList
      contentContainerStyle={styles.contentContainer}
      data={data}
      ListEmptyComponent={emptyComponent}
      keyExtractor={item => item}
      renderItem={renderItem}
      refreshing={isLoading}
    />
  );
}

const styles = StyleSheet.create({
  contentContainer: {
    paddingTop: 20,
  },
  emptyText: {
    textAlign: 'center',
  },
});
