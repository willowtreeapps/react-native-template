import {StyleSheet, Text, View} from 'react-native';
import {TodoCount} from '../components/TodoCount/TodoCount';
import {useTheme} from '../hooks/useTheme';

export function HomeScreen() {
  const theme = useTheme();

  return (
    <View style={[styles.container, {backgroundColor: theme.backgroundColor}]}>
      <Text style={[styles.text, {color: theme.textColor}]}>Hello World!</Text>
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
