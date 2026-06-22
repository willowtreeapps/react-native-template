import {
  Platform,
  // eslint-disable-next-line no-restricted-imports
  Text as RNText,
  StyleSheet,
  TextProps,
  useColorScheme,
} from 'react-native';
import { Grayscale } from '../theme/colors';

interface ThemedTextProps extends TextProps {
  lightColor?: Grayscale;
  darkColor?: Grayscale;
}

export function ThemedText({
  lightColor = Grayscale.black,
  darkColor = Grayscale.white,
  ...props
}: ThemedTextProps) {
  const colorScheme = useColorScheme();
  const color = colorScheme === 'dark' ? darkColor : lightColor;

  const style = StyleSheet.flatten([{ color }, props.style]);

  // iOS specific handling for italic fonts
  if (
    Platform.OS === 'ios' &&
    style.fontFamily?.toLowerCase().includes('italic')
  ) {
    style.fontStyle = 'italic';
  }

  return <RNText {...props} style={style} />;
}
