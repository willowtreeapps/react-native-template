# Testing Rules

## Two Testing Layers

This project has two distinct test layers. Use each for its intended purpose:

| Layer | Tool | Location | What to test |
|---|---|---|---|
| Unit / component | Jest + React Native Testing Library | Next to the source file | Logic, rendering, interactions |
| End-to-end | Maestro | `e2e/` | Full user flows on a real device/simulator |

## Unit Tests

### File location

Colocate test files next to the file they test. Do not create a separate `__tests__` directory.

```
src/components/TodoCount/
  TodoCount.tsx
  TodoCount.test.tsx       ✓ correct
  TodoCount.stories.tsx
```

### Naming convention

```ts
describe('TodoCount', () => {
  it('should render the count returned by the API', () => { ... });
  it('should show a loading state while fetching', () => { ... });
});
```

- `describe` block = component or function name
- `it` block = starts with `should`, describes observable behavior

### What to test

- Rendered output given different props/state
- User interactions (press, input)
- Hook return values and side effects
- Utility function correctness

### What NOT to test

- Implementation details (internal state, private methods)
- Third-party library behavior
- Styles (unless a style drives a behavior)

### React Query in tests

Use the `jestWrapper` utility from `@/utils/jestWrapper` to wrap components that use React Query:

```tsx
import {jestWrapper} from '@/utils/jestWrapper';

render(<TodoCount />, {wrapper: jestWrapper});
```

## End-to-End Tests (Maestro)

### File location

All `.yml` flows live in `e2e/`. One file per user flow.

```
e2e/
  home.yml
  login.yml
  checkout.yml
```

### Structure

```yaml
appId: com.yourorg.yourapp
---
- launchApp:
    arguments:
      isE2E: true
- assertVisible: "Expected text on screen"
- tapOn: "Button label"
```

- Always include `isE2E: true` in `launchApp` to suppress LogBox
- Prefer asserting by visible text or accessibility labels
- Avoid asserting on testIDs in Maestro — use `testIds.ts` constants only in unit tests

### Running e2e

```bash
yarn test:e2e
```

Requires a running simulator/emulator with the dev client already installed.
