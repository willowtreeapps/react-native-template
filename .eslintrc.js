module.exports = {
  root: true,
  extends: ['@react-native', 'plugin:@tanstack/query/recommended'],
  rules: {
    // don't allow nested ternaries
    'no-nested-ternary': 'error',
    // no longer needed with React 17
    'react/react-in-jsx-scope': 'off',
    // don't allow unused styles
    'react-native/no-unused-styles': 'error',
    // make sure all maps have a key
    'react/jsx-key': 'error',
    // guard against leaked values in renders
    'react/jsx-no-leaked-render': 'error',
    // defers quote style to Prettier
    quotes: 'off',
  },
  overrides: [
    {
      // Test files only
      files: ['**/__tests__/**/*.[jt]s?(x)', '**/?(*.)+(spec|test).[jt]s?(x)'],
      extends: ['plugin:testing-library/react'],
    },
  ],
};
