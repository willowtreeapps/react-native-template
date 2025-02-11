import {ActivityIndicator, Text} from 'react-native';
import {TEST_IDS} from '../../constants/testIds';
import {useTheme} from '../../hooks/useTheme';
import {useTodoQuery} from '../../hooks/useTodoQuery';

export const TodoCount = () => {
  const theme = useTheme();
  const todoQuery = useTodoQuery();

  if (todoQuery.isLoading) {
    return <ActivityIndicator testID={TEST_IDS.LOADING_INDICATOR} />;
  }

  return (
    <Text
      testID={TEST_IDS.TODO_COUNT}
      style={{
        color: theme.textColor,
      }}>{`Todo Count: ${todoQuery.data?.length}`}</Text>
  );
};
