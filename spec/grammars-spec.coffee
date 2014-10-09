CodeContext = require '../lib/code-context'
grammarMap = require '../lib/grammars'

describe 'grammarMap', ->
  beforeEach ->
    @_originalPlatform = process.platform
    @codeContext = new CodeContext('test.txt', '/tmp/test.txt', null)
    # TODO: Test using an actual editor or a selection?
    @dummyTextSource = {}
    @dummyTextSource.getText = -> ""

  afterEach ->
    process.platform = @_originalPlatform

  it "has a command and an args function set for each grammar's mode", ->
    @codeContext.textSource = @dummyTextSource
    for lang,modes of grammarMap
      for mode,commandContext of modes
        expect(commandContext.command).toBeDefined()
        argList = commandContext.args(@codeContext)
        expect(argList).toBeDefined()

  describe 'C', ->
    it 'returns the appropriate File Based runner on Mac OS X', ->
      process.platform = 'darwin'
      grammar = grammarMap['C']
      fileBasedRunner = grammar['File Based']
      args = fileBasedRunner.args(@codeContext)
      expect(fileBasedRunner.command).toEqual('bash')
      expect(args[0]).toEqual('-c')
      expect(args[1]).toMatch(/^xcrun clang/)

    it 'is not defined on other operating systems', ->
      process.platform = 'win32'
      grammar = grammarMap['C']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)

  describe 'C++', ->
    it 'returns the appropriate File Based runner on Mac OS X', ->
      process.platform = 'darwin'
      grammar = grammarMap['C++']
      fileBasedRunner = grammar['File Based']
      args = fileBasedRunner.args(@codeContext)
      expect(fileBasedRunner.command).toEqual('bash')
      expect(args[0]).toEqual('-c')
      expect(args[1]).toMatch(/^xcrun clang\+\+/)

    it 'is not defined on other operating systems', ->
      process.platform = 'win32'
      grammar = grammarMap['C++']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)

  describe 'Objective-C', ->
    it 'returns the appropriate File Based runner on Mac OS X', ->
      process.platform = 'darwin'
      grammar = grammarMap['Objective-C']
      fileBasedRunner = grammar['File Based']
      args = fileBasedRunner.args(@codeContext)
      expect(fileBasedRunner.command).toEqual('bash')
      expect(args[0]).toEqual('-c')
      expect(args[1]).toMatch(/^xcrun clang/)

    it 'is not defined on other operating systems', ->
      process.platform = 'win32'
      grammar = grammarMap['Objective-C']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)

  describe 'Objective-C++', ->
    it 'returns the appropriate File Based runner on Mac OS X', ->
      process.platform = 'darwin'
      grammar = grammarMap['Objective-C++']
      fileBasedRunner = grammar['File Based']
      args = fileBasedRunner.args(@codeContext)
      expect(fileBasedRunner.command).toEqual('bash')
      expect(args[0]).toEqual('-c')
      expect(args[1]).toMatch(/^xcrun clang\+\+/)

    it 'is not defined on other operating systems', ->
      process.platform = 'win32'
      grammar = grammarMap['Objective-C++']
      fileBasedRunner = grammar['File Based']
      expect(fileBasedRunner).toBe(undefined)
