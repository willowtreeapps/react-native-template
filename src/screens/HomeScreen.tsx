import {StyleSheet, View} from 'react-native';
import {TodoCount} from '../components/TodoCount/TodoCount';
import {useTheme} from '../hooks/useTheme';
import {ThemeText} from '../components/ThemeText';

export function HomeScreen() {
  const theme = useTheme();

  return (
    <View style={[styles.container, {backgroundColor: theme.backgroundColor}]}>
      <ThemeText style={styles.text}>Hello World!</ThemeText>
      <TodoCount />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 16,
  },
  text: {
    fontSize: 20,
  },
});
