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
      for mode of modes
        mode.command
        expect(mode.command).toBeDefined()
        argList = mode.args(@codeContext)
        expect(argList).toBeDefined()
