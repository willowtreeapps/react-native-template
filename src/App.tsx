import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import Constants from 'expo-constants';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { useReactQuery } from './hooks/useReactQuery';
import { HomeScreen } from './screens/HomeScreen';

let AppEntryPoint = HomeScreen;

if (Constants.expoConfig?.extra?.withStorybook === 'true') {
  AppEntryPoint = require('../.rnstorybook').default;
}

const queryClient = new QueryClient();

export default () => {
  useReactQuery(queryClient);

  return (
    <GestureHandlerRootView>
      <QueryClientProvider client={queryClient}>
        <AppEntryPoint />
      </QueryClientProvider>
    </GestureHandlerRootView>
  );
};
