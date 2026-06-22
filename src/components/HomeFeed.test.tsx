import { screen } from '@testing-library/react-native';
import { useHomeQuery } from '../hooks/useHomeQuery';
import { render } from '../utils/TestUtils';
import { HomeFeed } from './HomeFeed';

jest.mock('../hooks/useHomeQuery');

describe('HomeFeed', () => {
  test('renders a loading indicator', async () => {
    // no mock data
    jest.mocked(useHomeQuery).mockReturnValue({
      data: undefined,
      isLoading: true,
    } as any);

    await render(<HomeFeed />);
    expect(screen.getByTestId('loading-indicator')).toBeOnTheScreen();
  });

  test('does not render a loading indicator when data is available', async () => {
    // mock data available
    jest.mocked(useHomeQuery).mockReturnValue({
      data: ['Item 1', 'Item 2', 'Item 3'],
      isLoading: false,
    } as any);

    await render(<HomeFeed />);
    expect(screen.queryByTestId('loading-indicator')).toBeNull();
  });

  test('renders an error message when there is an error', async () => {
    // mock error state
    jest.mocked(useHomeQuery).mockReturnValue({
      data: undefined,
      isError: true,
    } as any);

    await render(<HomeFeed />);
    expect(screen.queryByTestId('loading-indicator')).toBeNull();
    expect(screen.getByText('An error occurred.')).toBeOnTheScreen();
  });
});
