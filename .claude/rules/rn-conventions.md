# React Native Conventions

## Component Structure

One component per file. The filename must match the exported component name.

Components are split into two tiers based on their scope of use:

### Shared components — `src/components/`

Components reused across **more than one screen** live in `src/components/`.

When creating a shared component, always ask the user:
> "Do you want a prefix for this component? (e.g. `App`, `UI`, `Base` → `AppButton`, `UICard`). Press enter to skip."

If a prefix is chosen, apply it consistently to all shared components.

For components with stories or tests, group them in a folder named after the component:

```
src/components/Button/
  Button.tsx               # component (or AppButton.tsx if prefix is "App")
  Button.test.tsx          # unit tests
  Button.stories.tsx       # Storybook stories (optional)
```

Simple components with no tests/stories can live as a single file:

```
src/components/ThemeText.tsx
```

### Local components — inside the screen folder

Components used by **only one screen** live alongside that screen, not in `src/components/`.

```
src/screens/
  HomeScreen.tsx
  HomeScreen.test.tsx
  components/              # local components — only used by HomeScreen
    HeroBanner.tsx
    StatsRow.tsx
```

**Decision rule:** If you're building a component and it's only needed in one place, put it local. If it gets reused in a second screen, move it to `src/components/` at that point.

## Screens vs Components

- **Screens** live in `src/screens/` and are named with a `Screen` suffix: `HomeScreen.tsx`
- **Screens** are the only place allowed to do data fetching (via hooks) and compose layout
- **Shared components** in `src/components/` should be pure/presentational where possible — receive data via props
- **Local components** inside screen folders follow the same rules but are scoped to that feature

## Custom Hooks

- All custom hooks live in `src/hooks/`
- Always prefix with `use`: `useTheme.ts`, `useTodoQuery.ts`
- One hook per file

## Theme System

Always use theme tokens from `src/theme/` for colors. Never hardcode color values.

```tsx
// Good
const theme = useTheme();
<View style={{backgroundColor: theme.backgroundColor}} />

// Bad
<View style={{backgroundColor: '#ffffff'}} />
```

Available tokens come from `useTheme()`. For typography scale, use `src/theme/typography.ts`.

## React Query

- Data fetching hooks live in `src/hooks/` and wrap React Query's `useQuery`/`useMutation`
- Configure the `QueryClient` in `src/hooks/useReactQuery.ts`
- Do not call `useQuery` directly in components — wrap it in a named hook

```ts
// Good — in src/hooks/useTodoQuery.ts
export function useTodoQuery() {
  return useQuery({queryKey: ['todos'], queryFn: fetchTodos});
}

// Bad — inside a component
const {data} = useQuery({queryKey: ['todos'], queryFn: fetchTodos});
```

## Storybook

- Story files use the `.stories.tsx` extension, colocated with the component
- Each story should reflect a meaningful state (loading, error, empty, populated)
- Run Storybook with: `yarn start:storybook`

## Accessibility

- Interactive elements must have an `accessibilityLabel` or visible text that Maestro can target
- Use `testIds.ts` constants from `@/utils/testIds` for `testID` props — never inline strings

```tsx
import {testIds} from '@/utils/testIds';

<TouchableOpacity testID={testIds.submitButton} />
```

## Animations

- Use `react-native-reanimated` for all animations — not the built-in `Animated` API
- Keep animation logic in hooks when it's reusable, or inline for one-off cases

## Platform-specific Code

Prefer cross-platform solutions. When platform-specific code is unavoidable, use `.ios.tsx` / `.android.tsx` file extensions rather than `Platform.OS` checks inside the component.
