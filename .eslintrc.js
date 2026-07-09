module.exports = {
  root: true,
  extends: [
    '@react-native',
    'plugin:jest/recommended',
    'plugin:@tanstack/query/recommended',
  ],
  plugins: ['eslint-comments', 'import', 'unused-imports'],
  rules: {
    // don't allow disabling of react-hooks/exhaustive-deps
    'eslint-comments/no-restricted-disable': [
      'error',
      'react-hooks/exhaustive-deps',
    ],
    // prefer named exports
    'import/no-default-export': 'error',
    // alphabetize imports
    'import/order': [
      'error',
      { alphabetize: { order: 'asc', caseInsensitive: true } },
    ],
    // don't allow nested ternaries
    'no-nested-ternary': 'error',
    // don't allow default React import
    'no-restricted-imports': [
      'error',
      {
        paths: [
          {
            name: 'react',
            importNames: ['default'],
            message:
              "As of React 17, you don't need to import React to use JSX. Please remove the default import.",
          },
          {
            name: 'react-native',
            importNames: ['Image'],
            message:
              'Use <Image /> from expo-image instead of <Image /> from react-native.',
          },
          {
            name: 'react-native',
            importNames: ['Text'],
            message:
              'Use <ThemedText /> instead of <Text /> from react-native.',
          },
        ],
      },
    ],
    // don't allow unused styles
    'react-native/no-unused-styles': 'error',
    // make sure all maps have a key
    'react/jsx-key': 'error',
    // guard against leaked values in renders
    'react/jsx-no-leaked-render': 'error',
    // removes unused imports with --fix
    'unused-imports/no-unused-imports': 'warn',
  },
  overrides: [
    {
      // Test files only
      files: ['**/__tests__/**/*.[jt]s?(x)', '**/?(*.)+(spec|test).[jt]s?(x)'],
      extends: ['plugin:testing-library/react'],
    },
    {
      // Expo Dynamic Config
      files: ['app.config.ts'],
      rules: {
        'import/no-default-export': 'off',
      },
    },
    {
      // Expo Router
      files: ['src/app/**/*.tsx'],
      rules: {
        'import/no-default-export': 'off',
      },
    },
  ],
};
