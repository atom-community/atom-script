'use babel';
import CodeContext from '../lib/code-context';
import OperatingSystem from '../lib/grammar-utils/operating-system';
import grammarMap from '../lib/grammars';

describe('grammarMap', function() {
  beforeEach(function() {
    this.codeContext = new CodeContext('test.txt', '/tmp/test.txt', null);
    // TODO: Test using an actual editor or a selection?
    this.dummyTextSource = {};
    return this.dummyTextSource.getText = () => "";
  });

  it("has a command and an args function set for each grammar's mode", function() {
    this.codeContext.textSource = this.dummyTextSource;
    return (() => {
      let result = [];
      for (let lang in grammarMap) {
        let modes = grammarMap[lang];
        result.push((() => {
          let result1 = [];
          for (let mode in modes) {
            let commandContext = modes[mode];
            expect(commandContext.command).toBeDefined();
            let argList = commandContext.args(this.codeContext);
            result1.push(expect(argList).toBeDefined());
          }
          return result1;
        })());
      }
      return result;
    })();
  });

  return describe('Operating system specific runners', function() {
    beforeEach(function() {
      this._originalPlatform = OperatingSystem.platform;
      return this.reloadGrammar = function() {
        delete require.cache[require.resolve('../lib/grammars.coffee')];
        return newGrammarMap = require('../lib/grammars.coffee');
      };
    });

    afterEach(function() {
      OperatingSystem.platform = this._originalPlatform;
      return this.reloadGrammar();
    });

    describe('C', () =>
      it('returns the appropriate File Based runner on Mac OS X', function() {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        let grammar = newGrammarMap['C'];
        let fileBasedRunner = grammar['File Based'];
        let args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang/);
      })
    );

    describe('C++', () =>
      it('returns the appropriate File Based runner on Mac OS X', function() {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        let grammar = newGrammarMap['C++'];
        let fileBasedRunner = grammar['File Based'];
        let args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang\+\+/);
      })
    );

    describe('F#', function() {
      it('returns "fsi" as command for File Based runner on Windows', function() {
        OperatingSystem.platform = () => 'win32';
        this.reloadGrammar();

        let grammar = newGrammarMap['F#'];
        let fileBasedRunner = grammar['File Based'];
        let args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('fsi');
        expect(args[0]).toEqual('--exec');
        return expect(args[1]).toEqual(this.codeContext.filepath);
      });

      return it('returns "fsharpi" as command for File Based runner when platform is not Windows', function() {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        let grammar = newGrammarMap['F#'];
        let fileBasedRunner = grammar['File Based'];
        let args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('fsharpi');
        expect(args[0]).toEqual('--exec');
        return expect(args[1]).toEqual(this.codeContext.filepath);
      });
    });

    describe('Objective-C', () =>
      it('returns the appropriate File Based runner on Mac OS X', function() {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        let grammar = newGrammarMap['Objective-C'];
        let fileBasedRunner = grammar['File Based'];
        let args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang/);
      })
    );

    return describe('Objective-C++', () =>
      it('returns the appropriate File Based runner on Mac OS X', function() {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        let grammar = newGrammarMap['Objective-C++'];
        let fileBasedRunner = grammar['File Based'];
        let args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        return expect(args[1]).toMatch(/^xcrun clang\+\+/);
      })
    );
  });
});
