import eslintjs from "@eslint/js";
import globals from 'globals';

const {configs: eslintConfigs} = eslintjs;

export default [
  {
    ignores: [
      'coverage/'
    ],
  },
  eslintConfigs["recommended"],
  {
    files: ['test/**/*.js'],
    languageOptions: {
      globals: {
        ...globals.browser,
      }
    }
  },
  {
    files: ['test/**/*.js'],
    languageOptions: {
      globals: {
        ...globals.mocha,
        ...globals.node,
      }
    }
  }
];
