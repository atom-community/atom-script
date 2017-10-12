'use babel';

import path from 'path';
import GrammarUtils, { command } from '../grammar-utils';

const babel = path.join(__dirname, '../..', 'node_modules', '.bin', 'babel');

const args = ({ filepath }) => {
  const cmd = `'${babel}' --filename '${babel}' < '${filepath}'| node`;
  return GrammarUtils.formatArgs(cmd);
};
exports.Dart = {
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
};
exports.JavaScript = {
  'Selection Based': {
    command,
    args: (context) => {
      const code = context.getCode();
      const filepath = GrammarUtils.createTempFileWithCode(code, '.js');
      return args({ filepath });
    },
  },
  'File Based': { command, args },
};
exports['Babel ES6 JavaScript'] = exports.JavaScript;
exports['JavaScript with JSX'] = exports.JavaScript;

exports['JavaScript for Automation (JXA)'] = {
  'Selection Based': {
    command: 'osascript',
    args: context => ['-l', 'JavaScript', '-e', context.getCode()],
  },
  'File Based': {
    command: 'osascript',
    args: ({ filepath }) => ['-l', 'JavaScript', filepath],
  },
};
exports.TypeScript = {
  'Selection Based': {
    command: 'ts-node',
    args: context => ['-e', context.getCode()],
  },
  'File Based': {
    command: 'ts-node',
    args: ({ filepath }) => [filepath],
  },
};
