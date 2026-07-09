import { useReactQueryDevTools } from '@dev-plugins/react-query';
import {
  QueryClient,
  focusManager,
  onlineManager,
} from '@tanstack/react-query';
import * as Network from 'expo-network';
import { useEffect } from 'react';
import { AppState, AppStateStatus, Platform } from 'react-native';

// refetch any stale queries when back online
onlineManager.setEventListener(setOnline => {
  let initialised = false;

  const eventSubscription = Network.addNetworkStateListener(state => {
    initialised = true;
    setOnline(!!state.isConnected);
  });

  Network.getNetworkStateAsync()
    .then(state => {
      if (!initialised) {
        setOnline(!!state.isConnected);
      }
    })
    .catch(() => {
      // getNetworkStateAsync can reject on some platforms/SDK versions
    });

  return eventSubscription.remove;
});

function onAppStateChange(status: AppStateStatus) {
  if (Platform.OS !== 'web') {
    focusManager.setFocused(status === 'active');
  }
}

// this is a custom hook that sets up additional react-query features for React Native
export function useReactQuery(queryClient: QueryClient) {
  // enable react query dev tools
  useReactQueryDevTools(queryClient);

  // refetch any stale queries when app state changes
  useEffect(() => {
    const subscription = AppState.addEventListener('change', onAppStateChange);

    return () => subscription.remove();
  }, []);
}
