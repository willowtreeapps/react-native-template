module.exports = {
  root: true,
  extends: [
    '@react-native',
    'plugin:jest/recommended',
    'plugin:@tanstack/query/recommended',
  ],
  rules: {
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
        ],
      },
    ],
    // don't allow unused styles
    'react-native/no-unused-styles': 'error',
    // make sure all maps have a key
    'react/jsx-key': 'error',
    // guard against leaked values in renders
    'react/jsx-no-leaked-render': 'error',
  },
  overrides: [
    {
      // Test files only
      files: ['**/__tests__/**/*.[jt]s?(x)', '**/?(*.)+(spec|test).[jt]s?(x)'],
      extends: ['plugin:testing-library/react'],
    },
  ],
  parserOptions: {
    warnOnUnsupportedTypeScriptVersion: false,
  },
};
