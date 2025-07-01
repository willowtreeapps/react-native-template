import {FlatList, StyleSheet} from 'react-native';
import {typography} from '../../theme/typography';
import {ThemeText} from '../ThemeText';

interface Props {
  text?: string;
}

export function TypographyList({text}: Props) {
  const typeStyles = Object.entries(typography);

  return (
    <FlatList
      contentContainerStyle={styles.contentContainer}
      data={typeStyles}
      keyExtractor={([styleName]) => styleName}
      renderItem={({item}) => {
        const [styleName, styleValue] = item;
        return <ThemeText style={styleValue}>{text || styleName}</ThemeText>;
      }}
    />
  );
}

const styles = StyleSheet.create({
  contentContainer: {
    gap: 16,
  },
});
