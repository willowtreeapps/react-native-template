import { Image } from 'expo-image';
import { Link } from 'expo-router';
import { Pressable, StyleSheet, View } from 'react-native';
import { Grayscale } from '../theme/colors';
import { isStorybook } from '../utils/isStorybook';
import { isTest } from '../utils/isTest';
import { ThemedText } from './ThemedText';

interface Props {
  item: string;
}

export function ContentCard({ item }: Props) {
  return (
    <Link href="/article" asChild>
      <Link.Trigger>
        <Pressable>
          <View style={styles.row}>
            <ThemedText style={styles.itemTitle}>{item}</ThemedText>
            <Image
              source={{ uri: 'https://picsum.photos/100/100' }}
              style={styles.thumbnail}
            />
          </View>
        </Pressable>
      </Link.Trigger>
      {!isTest && !isStorybook && <Link.Preview />}
    </Link>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  itemTitle: {
    flex: 1,
  },
  thumbnail: {
    backgroundColor: Grayscale.gray,
    height: 100,
    width: 100,
  },
});
