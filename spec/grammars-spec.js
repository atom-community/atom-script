'use babel';

import CodeContext from '../lib/code-context';
import OperatingSystem from '../lib/grammar-utils/operating-system';
import grammarMap from '../lib/grammars';

describe('grammarMap', () => {
  beforeEach(function () {
    this.codeContext = new CodeContext('test.txt', '/tmp/test.txt', null);
    // TODO: Test using an actual editor or a selection?
    this.dummyTextSource = {};
    return this.dummyTextSource.getText = () => '';
  });

  it("has a command and an args function set for each grammar's mode", function () {
    this.codeContext.textSource = this.dummyTextSource;
    return (() => {
      const result = [];
      for (const lang in grammarMap) {
        const modes = grammarMap[lang];
        result.push((() => {
          const result1 = [];
          for (const mode in modes) {
            const commandContext = modes[mode];
            expect(commandContext.command).toBeDefined();
            const argList = commandContext.args(this.codeContext);
            result1.push(expect(argList).toBeDefined());
          }
          return result1;
        })());
      }
      return result;
    })();
  });

  return describe('Operating system specific runners', () => {
    beforeEach(function () {
      this._originalPlatform = OperatingSystem.platform;
      return this.reloadGrammar = function () {
        delete require.cache[require.resolve('../lib/grammars.coffee')];
        return newGrammarMap = require('../lib/grammars.coffee');
      };
    });

    afterEach(function () {
      OperatingSystem.platform = this._originalPlatform;
      return this.reloadGrammar();
    });

    describe('C', () =>
      it('returns the appropriate File Based runner on Mac OS X', function () {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = newGrammarMap.C;
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang/);
      }),
    );

    describe('C++', () =>
      it('returns the appropriate File Based runner on Mac OS X', function () {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = newGrammarMap['C++'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang\+\+/);
      }),
    );

    describe('F#', () => {
      it('returns "fsi" as command for File Based runner on Windows', function () {
        OperatingSystem.platform = () => 'win32';
        this.reloadGrammar();

        const grammar = newGrammarMap['F#'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('fsi');
        expect(args[0]).toEqual('--exec');
        return expect(args[1]).toEqual(this.codeContext.filepath);
      });

      return it('returns "fsharpi" as command for File Based runner when platform is not Windows', function () {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = newGrammarMap['F#'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('fsharpi');
        expect(args[0]).toEqual('--exec');
        return expect(args[1]).toEqual(this.codeContext.filepath);
      });
    });

    describe('Objective-C', () =>
      it('returns the appropriate File Based runner on Mac OS X', function () {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = newGrammarMap['Objective-C'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang/);
      }),
    );

    return describe('Objective-C++', () =>
      it('returns the appropriate File Based runner on Mac OS X', function () {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = newGrammarMap['Objective-C++'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang\+\+/);
      }),
    );
  });
});
