import {
  Platform,
  Text as RNText,
  StyleSheet,
  TextProps,
  TextStyle,
} from 'react-native';
import {useTheme} from '../hooks/useTheme';

type FontStyle = TextStyle['fontStyle'];

export function ThemeText(props: TextProps) {
  const theme = useTheme();

  // iOS specific handling for italic fonts
  let fontStyle: FontStyle;
  if (Platform.OS === 'ios' && props.style) {
    const style = Array.isArray(props.style)
      ? StyleSheet.flatten(props.style)
      : props.style;

    if (
      typeof style === 'object' &&
      style.fontFamily?.toLowerCase().includes('italic')
    ) {
      fontStyle = 'italic';
    }
  }

  return (
    <RNText
      {...props}
      style={[
        {
          color: theme.textColor,
          fontStyle,
        },
        props.style,
      ]}
    />
  );
}
