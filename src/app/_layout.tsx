import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { Platform } from 'react-native';
import { AppProviders } from '../AppProviders';

export default function RootLayout() {
  return (
    <>
      <StatusBar style="auto" />
      <AppProviders>
        <Stack
          screenOptions={{
            headerBackButtonDisplayMode: 'minimal',
            headerTransparent: Platform.OS === 'ios',
          }}
        >
          <Stack.Screen
            name="(tabs)"
            options={{
              headerShown: false,
              title: 'Home',
            }}
          />
          <Stack.Screen
            name="article"
            options={{
              title: 'Article',
            }}
          />
        </Stack>
      </AppProviders>
    </>
  );
}
