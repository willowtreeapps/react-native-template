import { StyleSheet, View } from 'react-native';
import { ThemedText } from '../../../components/ThemedText';

export default function SettingsScreen() {
  return (
    <View style={styles.container}>
      <ThemedText>Settings</ThemedText>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
