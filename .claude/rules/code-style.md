# Code Style Rules

## TypeScript

- `strict: true` is enforced — never use `any`. Use `unknown` + type narrowing when the type is genuinely unknown.
- Prefer explicit return types on functions exported from a module.
- Use `interface` for object shapes, `type` for unions/intersections and utility types.

## Imports — No Barrel Pattern

Do not create `index.ts` files that re-export everything from a folder. Import directly from the source file.

```ts
// Good
import {useTheme} from '@/hooks/useTheme';
import {HomeScreen} from '@/screens/HomeScreen';

// Bad — barrel file anti-pattern
import {useTheme, useTodoQuery} from '@/hooks';
import {HomeScreen} from '@/screens';
```

**Why:** Barrel files cause circular dependency issues, slow down Metro's module resolution, and make tree-shaking harder.

**Exception:** `src/theme/index.ts` is the intentional public API for the theme module — this is fine because it's a cohesive module with a single purpose, not a re-export of everything.

## Path Aliases

Always use `@/` alias for imports inside `src/`. Never use relative paths that go up more than one level.

```ts
// Good
import {Colors} from '@/theme/types';
import {testIds} from '@/utils/testIds';

// Bad
import {Colors} from '../../theme/types';
import {testIds} from '../../../utils/testIds';
```

The alias resolves to `src/*` as configured in `tsconfig.json`.

## Styling

Never use inline styles. Always use `StyleSheet.create()` or theme tokens.

```tsx
// Good
const styles = StyleSheet.create({
  container: {flex: 1, padding: 16},
});

// Bad
<View style={{flex: 1, padding: 16}} />
```

For dynamic values driven by theme (colors, etc.), combine `StyleSheet` styles with a single dynamic property:

```tsx
<View style={[styles.container, {backgroundColor: theme.backgroundColor}]} />
```

## File Naming

- Components: `PascalCase.tsx` — one component per file, filename matches component name
- Hooks: `camelCase.ts` with `use` prefix — e.g., `useTheme.ts`
- Utilities: `camelCase.ts` — e.g., `testIds.ts`
- Screens: `PascalCase.tsx` with `Screen` suffix — e.g., `HomeScreen.tsx`

## Exports

Use named exports. Avoid default exports except for the root `App` component.

```ts
// Good
export function HomeScreen() { ... }

// Bad
export default function HomeScreen() { ... }
```
