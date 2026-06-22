import { SectionList, StyleSheet, useColorScheme, View } from 'react-native';
import { ThemedText } from '../../src/components/ThemedText';
import { Grayscale, Primary, Secondary } from '../../src/theme/colors';

type ColorItem = [string, string];
type ColorSection = {
  title: string;
  data: ColorItem[];
};

export function ColorList() {
  const colorScheme = useColorScheme();
  const borderColor =
    colorScheme === 'dark' ? Grayscale.white : Grayscale.black;

  const sections: ColorSection[] = [
    { title: 'Primary', data: Object.entries(Primary) },
    { title: 'Secondary', data: Object.entries(Secondary) },
    { title: 'Grayscale', data: Object.entries(Grayscale) },
  ];

  return (
    <SectionList
      sections={sections}
      keyExtractor={([colorName], index) => `${colorName}-${index}`}
      renderSectionHeader={({ section }) => (
        <ThemedText style={styles.sectionHeader}>{section.title}</ThemedText>
      )}
      renderItem={({ item }) => {
        const [colorName, hexCode] = item;
        return (
          <>
            <View
              style={[
                styles.swatch,
                {
                  backgroundColor: hexCode,
                  borderColor,
                },
              ]}
            />
            <ThemedText>{colorName}</ThemedText>
            <ThemedText>{hexCode}</ThemedText>
          </>
        );
      }}
      contentContainerStyle={styles.contentContainer}
      stickySectionHeadersEnabled={false}
    />
  );
}

const styles = StyleSheet.create({
  contentContainer: {
    gap: 8,
    padding: 16,
  },
  sectionHeader: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  swatch: {
    borderWidth: 1,
    height: 100,
    width: 100,
  },
});
