import { StyleSheet, useColorScheme } from 'react-native';
import { Paragraph } from '../components/Paragraph';
import { ThemedList } from '../components/ThemedList';
import { Grayscale } from '../theme/colors';

const PARAGRAPHS = [
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse facilisis lacus vel libero finibus, vitae feugiat justo ultrices. Sed elementum nisl in lectus commodo, eu vestibulum erat egestas.',
  'Praesent a augue non lectus egestas dignissim. Integer luctus, erat at sodales tincidunt, sapien nibh posuere justo, eget porttitor velit quam vel dolor. Sed ut justo id lorem varius egestas.',
  'Donec pulvinar ante at sem congue, non varius tellus aliquet. Curabitur a est in mauris fermentum pellentesque. Nam dictum, velit quis gravida posuere, sapien turpis eleifend nunc, id convallis orci massa non justo.',
  'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean in libero tortor. Duis quis augue id eros euismod convallis vitae sed urna. Cras eleifend magna sed neque porttitor, non pulvinar sem posuere.',
  'Mauris non neque vitae justo pharetra pretium. In tincidunt arcu nec lorem dictum, id suscipit dui feugiat. Integer placerat erat ac odio dictum, non viverra odio pharetra. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
  'Aliquam erat volutpat. Nunc ac malesuada sem. Morbi ac massa turpis. Maecenas tincidunt purus in velit vehicula, eu cursus urna rhoncus. Integer nec tincidunt nibh, at sodales leo.',
  'Phasellus volutpat tincidunt nunc, eu imperdiet velit mattis vel. Cras blandit tincidunt sem, vitae scelerisque nisl vulputate in. In facilisis justo quis erat fringilla, vel feugiat lorem congue.',
  'Ut hendrerit est eu augue faucibus, in ullamcorper tortor vestibulum. Proin sed diam quis lectus dignissim malesuada. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
  'Suspendisse potenti. Nulla facilisi. Curabitur ac sem id mauris tincidunt sollicitudin. Quisque et lorem feugiat, tincidunt lacus a, bibendum magna. Sed malesuada consectetur nunc vitae pellentesque.',
  'Nam ornare, est vitae tincidunt iaculis, ligula velit faucibus lectus, sit amet iaculis sapien velit sit amet elit. Vivamus non ipsum vitae turpis varius varius non non justo.',
];

function renderItem({ item }: { item: string }) {
  return <Paragraph text={item} />;
}

export default function ArticleScreen() {
  const colorScheme = useColorScheme();
  const backgroundColor =
    colorScheme === 'dark' ? Grayscale.black : Grayscale.white;

  return (
    <ThemedList
      contentContainerStyle={styles.contentContainer}
      data={PARAGRAPHS}
      renderItem={renderItem}
      style={{
        backgroundColor,
      }}
    />
  );
}

const styles = StyleSheet.create({
  contentContainer: {
    padding: 16,
  },
});
