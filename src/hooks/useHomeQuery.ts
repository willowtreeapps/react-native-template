import { useQuery } from '@tanstack/react-query';

export function useHomeQuery() {
  return useQuery({
    queryKey: ['home'],
    queryFn: async () => {
      await new Promise(resolve => setTimeout(resolve, 2000)); // wait 2s to simulate a network request
      return Array.from({ length: 100 }, (_, i) => `Item ${i + 1}`);
    },
  });
}
