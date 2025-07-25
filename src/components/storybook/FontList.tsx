import {getLoadedFonts} from 'expo-font';
import {FlatList, StyleSheet} from 'react-native';
import {ThemeText} from '../ThemeText';

export function FontList() {
  const uniqueFonts = [...new Set(getLoadedFonts())].sort();

  return (
    <FlatList
      contentContainerStyle={styles.contentContainer}
      data={uniqueFonts}
      keyExtractor={item => item}
      renderItem={({item}) => (
        <ThemeText
          style={[
            styles.text,
            {
              fontFamily: item,
            },
          ]}>
          {item}
        </ThemeText>
      )}
    />
  );
}

const styles = StyleSheet.create({
  contentContainer: {
    gap: 16,
  },
  text: {
    fontSize: 30,
  },
});
