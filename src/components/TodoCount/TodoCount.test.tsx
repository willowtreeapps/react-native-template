import {render, screen} from '@testing-library/react-native';
import {useColorScheme} from 'react-native';
import {TodoCount} from './TodoCount';
import {TEST_IDS} from '../../constants/testIds';
import {useTodoQuery} from '../../hooks/useTodoQuery';
import {jestWrapper} from '../../utils/jestWrapper';
import {Colors} from '../../theme/types';

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
      expect(ele.props.style.color).toBe(Colors.black);
    });

    test('dark mode', () => {
      jest.mocked(useColorScheme).mockReturnValue('dark');

      render(jestWrapper(TodoCount));

      const ele = screen.getByTestId(TEST_IDS.TODO_COUNT);
      expect(ele.props.style.color).toBe(Colors.white);
    });
  });
});
