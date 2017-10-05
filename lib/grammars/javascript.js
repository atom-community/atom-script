'use babel';

import GrammarUtils from '../grammar-utils';

export default {
  'Babel ES6 JavaScript': {
    'Selection Based': {
      command: 'babel-node',
      args: context => ['-e', context.getCode()],
    },
    'File Based': {
      command: 'babel-node',
      args: context => [context.filepath],
    },
  },
  Dart: {
    'Selection Based': {
      command: 'dart',
      args: (context) => {
        const code = context.getCode();
        const tmpFile = GrammarUtils.createTempFileWithCode(code, '.dart');
        return [tmpFile];
      },
    },
    'File Based': {
      command: 'dart',
      args: ({ filepath }) => [filepath],
    },
  },
  JavaScript: {
    'Selection Based': {
      command: 'babel-node',
      args: context => ['-e', context.getCode()],
    },
    'File Based': {
      command: 'babel-node',
      args: ({ filepath }) => [filepath],
    },
  },
  'JavaScript for Automation (JXA)': {
    'Selection Based': {
      command: 'osascript',
      args: context => ['-l', 'JavaScript', '-e', context.getCode()],
    },
    'File Based': {
      command: 'osascript',
      args: ({ filepath }) => ['-l', 'JavaScript', filepath],
    },
  },
  'JavaScript with JSX': {
    'Selection Based': {
      command: 'babel-node',
      args: context => ['-e', context.getCode()],
    },
    'File Based': {
      command: 'babel-node',
      args: ({ filepath }) => [filepath],
    },
  },
  TypeScript: {
    'Selection Based': {
      command: 'ts-node',
      args: context => ['-e', context.getCode()],
    },
    'File Based': {
      command: 'ts-node',
      args: ({ filepath }) => [filepath],
    },
  },
};
