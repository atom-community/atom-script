CodeContext = require '../lib/code-context'

describe 'CodeContext', ->
  beforeEach ->
    @codeContext = new CodeContext('test.txt', '/tmp/test.txt', null)
    # TODO: Test using an actual editor or a selection?
    @dummyTextSource = {}
    @dummyTextSource.getText = ->
      "print 'hello world!'"

  describe 'fileColonLine when lineNumber is not set', ->
    it 'returns the full filepath when fullPath is truthy', ->
      expect(@codeContext.fileColonLine()).toMatch("/tmp/test.txt")
      expect(@codeContext.fileColonLine(true)).toMatch("/tmp/test.txt")

    it 'returns only the filename and line number when fullPath is falsy', ->
      expect(@codeContext.fileColonLine(false)).toMatch("test.txt")

  describe 'fileColonLine when lineNumber is set', ->
    it 'returns the full filepath when fullPath is truthy', ->
      @codeContext.lineNumber = 42
      expect(@codeContext.fileColonLine()).toMatch("/tmp/test.txt")
      expect(@codeContext.fileColonLine(true)).toMatch("/tmp/test.txt")

    it 'returns only the filename and line number when fullPath is falsy', ->
      @codeContext.lineNumber = 42
      expect(@codeContext.fileColonLine(false)).toMatch("test.txt")

  describe 'getCode', ->
    it 'returns undefined if no textSource is available', ->
      expect(@codeContext.getCode()).toBe(undefined)

    it 'returns a string prepended with newlines when prependNewlines is truthy', ->
      @codeContext.textSource = @dummyTextSource
      @codeContext.lineNumber = 3

      code = @codeContext.getCode(true)
      expect(typeof code).toEqual('string')
      # Since Array#join will create newlines for one less than the the number
      # of elements line number 3 means there should be two newlines
      expect(code).toMatch("\n\nprint 'hello world!'")

    it 'returns the text from the textSource when available', ->
      @codeContext.textSource = @dummyTextSource

      code = @codeContext.getCode()
      expect(typeof code).toEqual('string')
      expect(code).toMatch("print 'hello world!'")

  describe 'shebangCommand when no shebang was found', ->
    it 'returns undefined when no shebang is found', ->
      lines = @dummyTextSource.getText()
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      expect(@codeContext.shebangCommand()).toBe(undefined)

  describe 'shebangCommand when a shebang was found', ->
    it 'returns the command from the shebang', ->
      lines = "#!/bin/bash\necho 'hello from bash!'"
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      expect(@codeContext.shebangCommand()).toMatch('bash')

    it 'returns /usr/bin/env as the command if applicable', ->
      lines = "#!/usr/bin/env ruby -w\nputs 'hello from ruby!'"
      firstLine = lines.split("\n")[0]
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      expect(@codeContext.shebangCommand()).toMatch('env')

    it 'returns a command with non-alphabet characters', ->
      lines = "#!/usr/bin/python2.7\nprint 'hello from python!'"
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      expect(@codeContext.shebangCommand()).toMatch('python2.7')

  describe 'shebangCommandArgs when no shebang was found', ->
    it 'returns [] when no shebang is found', ->
      lines = @dummyTextSource.getText()
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      expect(@codeContext.shebangCommandArgs()).toMatch([])

  describe 'shebangCommandArgs when a shebang was found', ->
    it 'returns the command from the shebang', ->
      lines = "#!/bin/bash\necho 'hello from bash!'"
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      expect(@codeContext.shebangCommandArgs()).toMatch([])

    it 'returns the true command as the first argument when /usr/bin/env is used', ->
      lines = "#!/usr/bin/env ruby -w\nputs 'hello from ruby!'"
      firstLine = lines.split("\n")[0]
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      args = @codeContext.shebangCommandArgs()
      expect(args[0]).toMatch('ruby')
      expect(args).toMatch(['ruby', '-w'])

    it 'returns the command args when the command had non-alphabet characters', ->
      lines = "#!/usr/bin/python2.7\nprint 'hello from python!'"
      firstLine = lines.split("\n")[0]
      @codeContext.shebang = firstLine if firstLine.match(/^#!/)
      expect(@codeContext.shebangCommandArgs()).toMatch([])
