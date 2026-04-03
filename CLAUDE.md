# React Native Template — Team Instructions

This is an Expo-managed React Native template using TypeScript, React Query, Reanimated, and Maestro for e2e testing.

## Project Structure

```
src/
  components/    # Reusable UI components (one component per folder)
  constants/     # App-wide constants
  hooks/         # Custom React hooks
  screens/       # Screen-level components
  theme/         # Design tokens (colors, typography, spacing)
  utils/         # Pure utility functions
e2e/             # Maestro end-to-end test flows
scripts/         # Shell scripts for setup and CI
```

## Path Aliases

Always use the `@/` alias instead of relative paths for imports within `src/`:

```ts
// Good
import {useTheme} from '@/hooks/useTheme';

// Bad
import {useTheme} from '../../hooks/useTheme';
```

## Key Rules

- See `.claude/rules/code-style.md` for TypeScript and import conventions
- See `.claude/rules/testing.md` for unit and e2e test conventions
- See `.claude/rules/rn-conventions.md` for React Native-specific patterns

## Available Scripts

| Command | Purpose |
|---|---|
| `yarn start` | Start Metro bundler |
| `yarn ios` | Run on iOS device |
| `yarn android` | Run on Android device |
| `yarn test` | Run Jest unit tests |
| `yarn test:e2e` | Run Maestro e2e tests |
| `yarn lint` | ESLint |
| `yarn format` | Prettier |

## Setup

```bash
./scripts/init.sh
```

## Branch Switching (QA)

QA engineers should use the branch switch script instead of manually switching branches:

```bash
./scripts/qa-branch-switch.sh <branch-name>
```

This validates the environment, cleans all caches, reinstalls dependencies, and rebuilds native projects automatically.

## Slash Commands

- `/deploy` — run prebuild and native setup for a target platform
- `/setup` — optional interactive wizard: analyzes the project, asks about your app, and suggests libraries to add. Nothing is installed until you confirm.
