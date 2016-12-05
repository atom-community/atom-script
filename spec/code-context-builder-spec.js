'use babel';

import CodeContextBuilder from '../lib/code-context-builder';

describe('CodeContextBuilder', () => {
  beforeEach(() => {
    this.editorMock = {
      getTitle() {},
      getPath() {},
      getText() {},
      getLastSelection() {
        return {
          isEmpty() {
            return false;
          },
        };
      },
      getGrammar() {
        return { name: 'JavaScript' };
      },
      getLastCursor() {},
      save() {},
    };

    spyOn(this.editorMock, 'getTitle').andReturn('file.js');
    spyOn(this.editorMock, 'getPath').andReturn('path/to/file.js');
    spyOn(this.editorMock, 'getText').andReturn('console.log("hello")\n');
    this.codeContextBuilder = new CodeContextBuilder();
  });

  describe('initCodeContext', () => {
    it('sets correct text source for empty selection', () => {
      const selection =
        { isEmpty() { return true; } };
      spyOn(this.editorMock, 'getLastSelection').andReturn(selection);
      const codeContext = this.codeContextBuilder.initCodeContext(this.editorMock);
      expect(codeContext.textSource).toEqual(this.editorMock);
      expect(codeContext.filename).toEqual('file.js');
      expect(codeContext.filepath).toEqual('path/to/file.js');
    });

    it('sets correct text source for non-empty selection', () => {
      const selection =
        { isEmpty() { return false; } };
      spyOn(this.editorMock, 'getLastSelection').andReturn(selection);
      const codeContext = this.codeContextBuilder.initCodeContext(this.editorMock);
      expect(codeContext.textSource).toEqual(selection);
      expect(codeContext.selection).toEqual(selection);
    });

    it('sets correct lang', () => {
      const codeContext = this.codeContextBuilder.initCodeContext(this.editorMock);
      expect(codeContext.lang).toEqual('JavaScript');
    });
  });

  describe('buildCodeContext', () =>
    ['Selection Based', 'Line Number Based'].map(argType =>
      it(`sets lineNumber with screenRow + 1 when ${argType}`, () => {
        const cursor =
          { getScreenRow() { return 1; } };
        spyOn(this.editorMock, 'getLastCursor').andReturn(cursor);
        const codeContext = this.codeContextBuilder.buildCodeContext(this.editorMock, argType);
        expect(codeContext.argType).toEqual(argType);
        expect(codeContext.lineNumber).toEqual(2);
      }),
    ),
  );
});
