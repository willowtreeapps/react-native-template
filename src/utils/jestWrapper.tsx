import {QueryClient, QueryClientProvider} from '@tanstack/react-query';
import {ComponentType} from 'react';

const queryClient = new QueryClient();

export function jestWrapper(Component: ComponentType) {
  return (
    <QueryClientProvider client={queryClient}>
      <Component />
    </QueryClientProvider>
  );
}
