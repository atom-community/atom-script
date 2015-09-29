CodeContextBuilder = require '../lib/code-context-builder'

describe 'CodeContextBuilder', ->
  beforeEach ->
    @editorMock =
      getTitle: ->
      getPath: ->
      getText: ->
      getLastSelection: ->
        isEmpty: ->
          false
      getGrammar: ->
        name: 'JavaScript'
      getLastCursor: ->
      save: ->

    spyOn(@editorMock, 'getTitle').andReturn('file.js')
    spyOn(@editorMock, 'getPath').andReturn('path/to/file.js')
    spyOn(@editorMock, 'getText').andReturn('console.log("hello")\n')
    @codeContextBuilder = new CodeContextBuilder

  describe 'initCodeContext', ->
    it 'sets correct text source for empty selection', ->
      selection =
        isEmpty: -> true
      spyOn(@editorMock, 'getLastSelection').andReturn(selection)
      codeContext = @codeContextBuilder.initCodeContext(@editorMock)
      expect(codeContext.textSource).toEqual(@editorMock)
      expect(codeContext.filename).toEqual('file.js')
      expect(codeContext.filepath).toEqual('path/to/file.js')

    it 'sets correct text source for non-empty selection', ->
      selection =
        isEmpty: -> false
      spyOn(@editorMock, 'getLastSelection').andReturn(selection)
      codeContext = @codeContextBuilder.initCodeContext(@editorMock)
      expect(codeContext.textSource).toEqual(selection)
      expect(codeContext.selection).toEqual(selection)

    it 'sets correct lang', ->
      codeContext = @codeContextBuilder.initCodeContext(@editorMock)
      expect(codeContext.lang).toEqual('JavaScript')

  describe 'buildCodeContext', ->
    for argType in ['Selection Based', 'Line Number Based']
      it "sets lineNumber with screenRow + 1 when #{argType}", ->
        cursor =
          getScreenRow: -> 1
        spyOn(@editorMock, 'getLastCursor').andReturn(cursor)
        codeContext = @codeContextBuilder.buildCodeContext(@editorMock, argType)
        expect(codeContext.argType).toEqual(argType)
        expect(codeContext.lineNumber).toEqual(2)
