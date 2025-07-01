import {FlatList, StyleSheet, View} from 'react-native';
import {Colors} from '../../theme/types';
import {ThemeText} from '../ThemeText';
import {useTheme} from '../../hooks/useTheme';

export function ColorList() {
  const theme = useTheme();

  const colors = Object.entries(Colors);

  return (
    <FlatList
      data={colors}
      keyExtractor={([colorName]) => colorName}
      numColumns={3}
      renderItem={({item}) => {
        const [colorName, hexCode] = item;
        return (
          <View style={styles.swatchContainer}>
            <View
              style={[
                styles.swatch,
                {backgroundColor: hexCode, borderColor: theme.textColor},
              ]}
            />
            <ThemeText>{colorName}</ThemeText>
          </View>
        );
      }}
    />
  );
}

const styles = StyleSheet.create({
  swatchContainer: {
    margin: 8,
  },
  swatch: {
    borderWidth: 1,
    height: 100,
    width: 100,
  },
});
