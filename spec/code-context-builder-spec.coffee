CodeContextBuilder = require '../lib/code-context-builder'

describe 'CodeContextBuilder', ->
  beforeEach ->
    @viewMock =
      showLanguageNotSupported: (lang) ->
      showNoLanguageSpecified: ->

    @editorMock =
      getTitle: ->
      getPath: ->
      getText: ->
      getLastSelection: ->
        isEmpty: ->
          false
      getGrammar: ->
        name: 'JavaScript'

    spyOn(@editorMock, 'getTitle').andReturn('file.js')
    spyOn(@editorMock, 'getPath').andReturn('path/to/file.js')
    spyOn(@editorMock, 'getText').andReturn('console.log("hello")\n')
    @codeContextBuilder = new CodeContextBuilder(@viewMock, @editorMock)

  describe 'initCodeContext', ->
    it 'sets correct text source for empty selection', ->
      selection =
        isEmpty: -> true
      spyOn(@editorMock, 'getLastSelection').andReturn(selection)
      codeContext = @codeContextBuilder.initCodeContext()
      expect(codeContext.textSource).toEqual(@editorMock)
      expect(codeContext.filename).toEqual('file.js')
      expect(codeContext.filepath).toEqual('path/to/file.js')

    it 'sets correct text source for non-empty selection', ->
      selection =
        isEmpty: -> false
      spyOn(@editorMock, 'getLastSelection').andReturn(selection)
      codeContext = @codeContextBuilder.initCodeContext()
      expect(codeContext.textSource).toEqual(selection)
      expect(codeContext.selection).toEqual(selection)

    it 'sets correct lang', ->
      codeContext = @codeContextBuilder.initCodeContext()
      expect(codeContext.lang).toEqual('JavaScript')
