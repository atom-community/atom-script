'use babel';
import CodeContextBuilder from '../lib/code-context-builder';

describe('CodeContextBuilder', function() {
  beforeEach(function() {
    this.editorMock = {
      getTitle() {},
      getPath() {},
      getText() {},
      getLastSelection() {
        return {
          isEmpty() {
            return false;
          }
        };
      },
      getGrammar() {
        return {name: 'JavaScript'};
      },
      getLastCursor() {},
      save() {}
    };

    spyOn(this.editorMock, 'getTitle').andReturn('file.js');
    spyOn(this.editorMock, 'getPath').andReturn('path/to/file.js');
    spyOn(this.editorMock, 'getText').andReturn('console.log("hello")\n');
    return this.codeContextBuilder = new CodeContextBuilder;
  });

  describe('initCodeContext', function() {
    it('sets correct text source for empty selection', function() {
      let selection =
        {isEmpty() { return true; }};
      spyOn(this.editorMock, 'getLastSelection').andReturn(selection);
      let codeContext = this.codeContextBuilder.initCodeContext(this.editorMock);
      expect(codeContext.textSource).toEqual(this.editorMock);
      expect(codeContext.filename).toEqual('file.js');
      return expect(codeContext.filepath).toEqual('path/to/file.js');
    });

    it('sets correct text source for non-empty selection', function() {
      let selection =
        {isEmpty() { return false; }};
      spyOn(this.editorMock, 'getLastSelection').andReturn(selection);
      let codeContext = this.codeContextBuilder.initCodeContext(this.editorMock);
      expect(codeContext.textSource).toEqual(selection);
      return expect(codeContext.selection).toEqual(selection);
    });

    return it('sets correct lang', function() {
      let codeContext = this.codeContextBuilder.initCodeContext(this.editorMock);
      return expect(codeContext.lang).toEqual('JavaScript');
    });
  });

  return describe('buildCodeContext', () =>
    ['Selection Based', 'Line Number Based'].map((argType) =>
      it(`sets lineNumber with screenRow + 1 when ${argType}`, function() {
        let cursor =
          {getScreenRow() { return 1; }};
        spyOn(this.editorMock, 'getLastCursor').andReturn(cursor);
        let codeContext = this.codeContextBuilder.buildCodeContext(this.editorMock, argType);
        expect(codeContext.argType).toEqual(argType);
        return expect(codeContext.lineNumber).toEqual(2);
      }))
  );
});
