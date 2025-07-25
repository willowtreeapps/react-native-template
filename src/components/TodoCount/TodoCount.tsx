import {ActivityIndicator} from 'react-native';
import {TEST_IDS} from '../../constants/testIds';
import {useTodoQuery} from '../../hooks/useTodoQuery';
import {ThemeText} from '../ThemeText';

export const TodoCount = () => {
  const todoQuery = useTodoQuery();

  if (todoQuery.isLoading) {
    return <ActivityIndicator testID={TEST_IDS.LOADING_INDICATOR} />;
  }

  return (
    <ThemeText
      testID={
        TEST_IDS.TODO_COUNT
      }>{`Todo Count: ${todoQuery.data?.length}`}</ThemeText>
  );
};
