CodeContext = require '../lib/code-context'
OperatingSystem = require '../lib/grammar-utils/operating-system'
grammarMap = require '../lib/grammars'

describe 'grammarMap', ->
  beforeEach ->
    @codeContext = new CodeContext('test.txt', '/tmp/test.txt', null)
    # TODO: Test using an actual editor or a selection?
    @dummyTextSource = {}
    @dummyTextSource.getText = -> ""

  it "has a command and an args function set for each grammar's mode", ->
    @codeContext.textSource = @dummyTextSource
    for lang,modes of grammarMap
      for mode,commandContext of modes
        expect(commandContext.command).toBeDefined()
        argList = commandContext.args(@codeContext)
        expect(argList).toBeDefined()

  describe 'Operating system specific runners', ->
    beforeEach ->
      @_originalPlatform = OperatingSystem.platform
      @reloadGrammar = ->
        delete require.cache[require.resolve('../lib/grammars.coffee')]
        grammarMap = require '../lib/grammars.coffee'

    afterEach ->
      OperatingSystem.platform = @_originalPlatform
      @reloadGrammar()

    describe 'C', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['C']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang/)

    describe 'C++', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['C++']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang\+\+/)

    describe 'F#', ->
      it 'returns "fsi" as command for File Based runner on Windows', ->
        OperatingSystem.platform = -> 'win32'
        @reloadGrammar()

        grammar = grammarMap['F#']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('fsi')
        expect(args[0]).toEqual('--exec')
        expect(args[1]).toEqual(@codeContext.filepath)

      it 'returns "fsharpi" as command for File Based runner when platform is not Windows', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['F#']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('fsharpi')
        expect(args[0]).toEqual('--exec')
        expect(args[1]).toEqual(@codeContext.filepath)

    describe 'Objective-C', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['Objective-C']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang/)

    describe 'Objective-C++', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['Objective-C++']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang\+\+/)
