'use babel';

/* eslint-disable no-unused-vars, global-require, no-undef */
import CodeContext from '../lib/code-context';
import OperatingSystem from '../lib/grammar-utils/operating-system';
import grammarMap from '../lib/grammars.coffee';

describe('grammarMap', () => {
  beforeEach(() => {
    this.codeContext = new CodeContext('test.txt', '/tmp/test.txt', null);
    // TODO: Test using an actual editor or a selection?
    this.dummyTextSource = {};
    this.dummyTextSource.getText = () => '';
  });

  it("has a command and an args function set for each grammar's mode", () => {
    this.codeContext.textSource = this.dummyTextSource;
    for (const lang in grammarMap) {
      const modes = grammarMap[lang];
      for (const mode in modes) {
        const commandContext = modes[mode];
        expect(commandContext.command).toBeDefined();
        const argList = commandContext.args(this.codeContext);
        expect(argList).toBeDefined();
      }
    }
  });

  describe('Operating system specific runners', () => {
    beforeEach(() => {
      this.originalPlatform = OperatingSystem.platform;
      this.reloadGrammar = () => {
        delete require.cache[require.resolve('../lib/grammars.coffee')];
        this.grammarMap = require('../lib/grammars.coffee');
      };
    });

    afterEach(() => {
      OperatingSystem.platform = this.originalPlatform;
      this.reloadGrammar();
    });

    describe('C', () =>
      it('returns the appropriate File Based runner on Mac OS X', () => {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = this.grammarMap.C;
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        expect(args[1]).toMatch(/^xcrun clang/);
      }),
    );

    describe('C++', () =>
      it('returns the appropriate File Based runner on Mac OS X', () => {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = this.grammarMap['C++'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        expect(args[1]).toMatch(/^xcrun clang\+\+/);
      }),
    );

    describe('F#', () => {
      it('returns "fsi" as command for File Based runner on Windows', () => {
        OperatingSystem.platform = () => 'win32';
        this.reloadGrammar();

        const grammar = this.grammarMap['F#'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('fsi');
        expect(args[0]).toEqual('--exec');
        expect(args[1]).toEqual(this.codeContext.filepath);
      });

      it('returns "fsharpi" as command for File Based runner when platform is not Windows', () => {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = this.grammarMap['F#'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('fsharpi');
        expect(args[0]).toEqual('--exec');
        expect(args[1]).toEqual(this.codeContext.filepath);
      });
    });

    describe('Objective-C', () =>
      it('returns the appropriate File Based runner on Mac OS X', () => {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = this.grammarMap['Objective-C'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        expect(args[1]).toMatch(/^xcrun clang/);
      }),
    );

    describe('Objective-C++', () =>
      it('returns the appropriate File Based runner on Mac OS X', () => {
        OperatingSystem.platform = () => 'darwin';
        this.reloadGrammar();

        const grammar = this.grammarMap['Objective-C++'];
        const fileBasedRunner = grammar['File Based'];
        const args = fileBasedRunner.args(this.codeContext);
        expect(fileBasedRunner.command).toEqual('bash');
        expect(args[0]).toEqual('-c');
        expect(args[1]).toMatch(/^xcrun clang\+\+/);
      }),
    );
  });
});
