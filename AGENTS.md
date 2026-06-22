# AGENTS.md

## Canonical References

- Expo docs: read exact versioned docs at <https://docs.expo.dev/versions/v56.0.0/> before writing Expo code.
- Testing docs: this project uses `@testing-library/react-native`.
  - Before writing or changing RNTL tests, read local docs in `node_modules/@testing-library/react-native/docs/`, starting with `node_modules/@testing-library/react-native/docs/guides/llm-guidelines.md`.

## Code Quality Guardrails

### ESLint And Linting

- Never add eslint-disable comments or suppress lint warnings.
- Never use `// eslint-disable-next-line` or `/* eslint-disable */`.
- If a lint rule is triggered, fix the underlying issue instead of suppressing it.
- Refactor code to satisfy lint rules (for example by fixing dependencies, import usage, or control flow).

### React Best Practices

- Include complete dependency arrays in `useEffect`, `useCallback`, and `useMemo`.
- If a dependency should not trigger a re-run, restructure the code instead of omitting dependencies.
- Prefer explicit code changes over suppressing React Hooks lint warnings.

### General Quality Expectations

- Keep changes scoped and avoid unrelated refactors.
- Preserve existing public APIs unless the task explicitly requires a behavior change.
- Prefer correcting root causes (types, dependencies, data flow) over local suppressions.
- Add brief comments only when they explain non-obvious intent (the why), not obvious mechanics.

## Code Editing Workflow

After completing your code edits (especially when touching several files), run these commands once as a final validation step:

1. **`yarn eslint --fix <file>`** - Automatically fix linting issues:
   - Remove unused imports
   - Apply other auto-fixable ESLint rules
2. **`yarn prettier --write <file>`** - Format the code consistently
3. **`yarn tsc --noEmit`** - Check for TypeScript errors across the project

If all three commands pass successfully, there is no need to manually check for problems using the `get_errors` tool.

## Docs Impact Check (Required)

After each requested change:

1. Decide whether behavior, setup, scripts, structure, or workflow changed.
2. Update docs where needed (for example this `AGENTS.md`, `README.md`, and relevant records under `docs/adr/`).
3. Mention doc updates in your final summary.

## Native Workflow Guardrails

- Native folders are prebuild-managed. Treat `ios/` and `android/` as generated outputs from configured Expo/React Native state.
- Avoid casual hand-edits in native generated surfaces.
- If native dependencies or native config change, rerun `./scripts/prebuild.sh` for the affected platform.

## Project Conventions

- Keep changes minimal and aligned with existing architecture.
- For Expo/React Native dependencies, use `npx expo install <package>`.
- Do not add `Platform.OS === 'web'` branches or behavior.
- Do not add Expo Go-specific compatibility layers (for example Expo Go-safe barrel indirection).
- Do not guess backend/API property names or payload keys. If a contract is unclear, stop and ask for canonical fields.
- If implementation details are ambiguous (especially API contracts), ask for clarification before coding rather than guessing.
- Prefer `PropsWithChildren` for props that accept children.
- Prefer explicit React Native style typing (for example `Pick<TextStyle, 'fontWeight'>`) over broad `as const` style assertions.
- Do not add `estimatedItemSize` when implementing `FlashList` in this repo.
- Use `grep` for text/file searches in this environment.

## Project Map

- `src/app/` - Expo Router routes and layouts.
- `src/components/` - shared UI components and tests.
- `src/hooks/` - custom hooks for data/query integration.
- `src/theme/` - theme tokens and color primitives.
- `src/utils/` - runtime helpers and test utilities.
- `src/AppProviders.tsx` - root provider composition.

## Cloud Agent Execution Limits

- Cloud agents should run JavaScript-side tasks only.
- Supported in cloud: linting, formatting, unit tests, and TypeScript checks.
- Not supported in cloud: native/device-dependent workflows (for example `npm run ios`, `npm run android`, and E2E runs that require a simulator/device).
