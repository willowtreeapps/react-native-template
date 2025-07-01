import {useQuery, UseQueryResult} from '@tanstack/react-query';

type Todos = string[];

// note that we only return some properties of the full UseQueryResult
// this lets us write smaller mocks in tests
type TodoQueryResult = Pick<UseQueryResult<Todos>, 'data' | 'isLoading'>;

// sample data fetching query
export function useTodoQuery(): TodoQueryResult {
  const {data, isLoading} = useQuery<Todos>({
    queryKey: ['todos'],
    queryFn: () => {
      // fake a slow network request
      return new Promise(resolve =>
        setTimeout(() => resolve(['todo1', 'todo2']), 3000),
      );
    },
  });

  return {
    data,
    isLoading,
  };
}
