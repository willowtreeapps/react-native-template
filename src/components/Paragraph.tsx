import { StyleSheet } from 'react-native';
import { ThemedText } from './ThemedText';

interface Props {
  text: string;
}

export function Paragraph({ text }: Props) {
  return <ThemedText style={styles.paragraph}>{text}</ThemedText>;
}

const styles = StyleSheet.create({
  paragraph: {
    lineHeight: 24,
  },
});
