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

  describe 'shebangCommand', ->
    it 'returns undefined when no code is available', ->
      expect(@codeContext.shebangCommand()).toBe(undefined)

    it 'returns undefined when no shebang is found', ->
      @codeContext.textSource = @dummyTextSource
      expect(@codeContext.shebangCommand()).toBe(undefined)

    it 'returns the command name when a shebang is found', ->
      @codeContext.textSource = @dummyTextSource
      @codeContext.textSource.getText = ->
        "#!/bin/bash\necho 'hello from bash!'"
      expect(@codeContext.shebangCommand()).toMatch('bash')

      @codeContext.textSource.getText = ->
        "#!/usr/bin/env ruby\nputs 'hello from ruby!'"
      expect(@codeContext.shebangCommand()).toMatch('ruby')

      @codeContext.textSource.getText = ->
        "#!/usr/bin/python2.7\nprint 'hello from python!'"
      expect(@codeContext.shebangCommand()).toMatch('python2.7')

      @codeContext.textSource.getText = ->
        "#!/usr/bin/python3\nprint 'hello from python3!'"
      expect(@codeContext.shebangCommand()).toMatch('python3')
