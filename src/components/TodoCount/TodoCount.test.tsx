import { render, screen } from '@testing-library/react-native';
import { StyleSheet, useColorScheme } from 'react-native';
import { TEST_IDS } from '../../constants/testIds';
import { useTodoQuery } from '../../hooks/useTodoQuery';
import { Colors } from '../../theme/types';
import { jestWrapper } from '../../utils/jestWrapper';
import { TodoCount } from './TodoCount';

jest.mock('../../hooks/useTodoQuery');

describe('<TodoCount />', () => {
  describe('functionality', () => {
    test('Renders the loading indicator', () => {
      // no mock data
      jest.mocked(useTodoQuery).mockReturnValue({
        data: undefined,
        isLoading: true,
      });

      render(jestWrapper(TodoCount));

      screen.getByTestId(TEST_IDS.LOADING_INDICATOR);
    });

    test('Renders the data once fetched', () => {
      // preload mock data
      jest.mocked(useTodoQuery).mockReturnValue({
        data: ['todo1', 'todo2'],
        isLoading: false,
      });

      render(jestWrapper(TodoCount));

      screen.getByTestId(TEST_IDS.TODO_COUNT);
      screen.getByText('Todo Count: 2');
    });
  });

  describe('theming', () => {
    beforeEach(() => {
      // preload mock data
      jest.mocked(useTodoQuery).mockReturnValue({
        data: ['todo1', 'todo2'],
        isLoading: false,
      });
    });

    test('light mode', () => {
      render(jestWrapper(TodoCount));

      const ele = screen.getByTestId(TEST_IDS.TODO_COUNT);
      const style = StyleSheet.flatten(ele.props.style);
      expect(style.color).toBe(Colors.black);
    });

    test('dark mode', () => {
      jest.mocked(useColorScheme).mockReturnValue('dark');

      render(jestWrapper(TodoCount));

      const ele = screen.getByTestId(TEST_IDS.TODO_COUNT);
      const style = StyleSheet.flatten(ele.props.style);
      expect(style.color).toBe(Colors.white);
    });
  });
});
