'use babel';

/* eslint-disable no-underscore-dangle */
import ScriptOptionsView from '../lib/script-options-view';

describe('ScriptOptionsView', () => {
  describe('splitArgs', () => {
    [{
      text: '',
      expectedArgs: [],
      description: 'returns an empty array for empty string',
    }, {
      text: ' \t\n',
      expectedArgs: [],
      description: 'returns an empty array for just whitespace',
    }, {
      text: 'arg1 arg2',
      expectedArgs: ['arg1', 'arg2'],
      description: 'splits arguments on whitespace',
    }, {
      text: 'arg1=val1 arg2',
      expectedArgs: ['arg1=val1', 'arg2'],
      description: 'keeps argument values',
    }, {
      text: '"foo bar" arg2',
      expectedArgs: ['foo bar', 'arg2'],
      description: 'does not split quoted arguments on whitespace',
    }, {
      text: '\'foo bar\' arg2',
      expectedArgs: ['foo bar', 'arg2'],
      description: 'recognizes single quotes',
    }, {
      text: '"foo bar" "another string"',
      expectedArgs: ['foo bar', 'another string'],
      description: 'handles multiple quoted arguments',
    }, {
      text: '\'foo bar\' \'another string\'',
      expectedArgs: ['foo bar', 'another string'],
      description: 'handles multiple single quoted arguments',
    }, {
      text: '"foo bar" \'another string\'',
      expectedArgs: ['foo bar', 'another string'],
      description: 'handles multiple quoted arguments, with mixed single and double quotes',
    }, {
      text: 'arg1="foo bar"',
      expectedArgs: ['arg1=foo bar'],
      description: 'strips quotes from argument values',
    }, {
      text: 'arg1=\'foo bar\'',
      expectedArgs: ['arg1=foo bar'],
      description: 'strips single quotes from argument values',
    }, {
      text: '-e \'(load "{FILE_ACTIVE}")\'',
      expectedArgs: ['-e', '(load "{FILE_ACTIVE}")'],
      description: 'keeps nested quotes intact',
    }, {
      text: 'we"ird way to inc"l"ude spaces in arg"s',
      expectedArgs: ['weird way to include spaces in args'],
      description: 'supports multiple top level quotes',
    }].forEach(({ text, expectedArgs, description }) => {
      it(description, () => {
        const args = ScriptOptionsView.splitArgs(text);
        expect(args).toEqual(expectedArgs);
      });
    });
  });
});
