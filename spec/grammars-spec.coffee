CodeContext = require '../lib/code-context'
grammarMap = require '../lib/grammars'

describe 'grammarMap', ->
  beforeEach ->
    @codeContext = new CodeContext('test.txt', '/tmp/test.txt', null)
    # TODO: Test using an actual editor or a selection?
    @dummyTextSource = {}
    @dummyTextSource.getText = -> ""

  it 'has a command and an args function set for each grammar\'s mode', ->
    @codeContext.textSource = @dummyTextSource
    for lang,modes of grammarMap
      for mode,commandContext of modes
        expect(commandContext.command).toBeDefined()
        argList = commandContext.args(@codeContext)
        expect(argList).toBeDefined()

  describe 'C', ->
    it 'returns the "xcrun" File Based runner on Mac OS X', ->
      grammar = grammarMap['C']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner.command).toEqual('xcrun')

    it 'is not defined on other operating systems', ->
      grammar = grammarMap['C']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)

  describe 'C++', ->
    it 'returns the "xcrun" File Based runner on Mac OS X', ->
      grammar = grammarMap['C++']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner.command).toEqual('xcrun')

    it 'is not defined on other operating systems', ->
      grammar = grammarMap['C++']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)

  describe 'Objective-C', ->
    it 'returns the "xcrun" File Based runner on Mac OS X', ->
      grammar = grammarMap['Objective-C']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner.command).toEqual('xcrun')

    it 'is not defined on other operating systems', ->
      grammar = grammarMap['Objective-C']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)

  describe 'Objective-C++', ->
    it 'returns the "xcrun" File Based runner on Mac OS X', ->
      grammar = grammarMap['Objective-C++']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner.command).toEqual('xcrun')

    it 'is not defined on other operating systems', ->
      grammar = grammarMap['Objective-C++']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)
