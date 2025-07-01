import {QueryClient, QueryClientProvider} from '@tanstack/react-query';
import Constants from 'expo-constants';
import {useReactQuery} from './hooks/useReactQuery';
import {HomeScreen} from './screens/HomeScreen';

let AppEntryPoint = HomeScreen;

if (Constants.expoConfig?.extra?.withStorybook === 'true') {
  AppEntryPoint = require('../.rnstorybook').default;
}

const queryClient = new QueryClient();

export default () => {
  useReactQuery(queryClient);

  return (
    <QueryClientProvider client={queryClient}>
      <AppEntryPoint />
    </QueryClientProvider>
  );
};
