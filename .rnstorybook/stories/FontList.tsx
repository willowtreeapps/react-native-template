import { getLoadedFonts } from 'expo-font';
import { FlatList, StyleSheet } from 'react-native';
import { ThemedText } from '../../src/components/ThemedText';

interface Props {
  text: string;
}

export function FontList({ text }: Props) {
  const uniqueFonts = [...new Set(getLoadedFonts())].sort();

  return (
    <FlatList
      contentContainerStyle={styles.contentContainer}
      data={uniqueFonts}
      keyExtractor={item => item}
      renderItem={({ item }) => (
        <ThemedText
          style={[
            styles.text,
            {
              fontFamily: item,
            },
          ]}
        >
          {text || item}
        </ThemedText>
      )}
    />
  );
}

const styles = StyleSheet.create({
  contentContainer: {
    gap: 8,
    padding: 16,
  },
  text: {
    fontSize: 24,
  },
});
