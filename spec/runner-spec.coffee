Runner = require '../lib/runner'
ScriptOptions = require '../lib/script-options'

describe 'Runner', ->
  beforeEach ->
    @command = 'node'
    @runOptions = new ScriptOptions
    @runOptions.cmd = @command
    @runner = new Runner(@runOptions)

  afterEach ->
    @runner.destroy()

  describe 'run', ->
    it 'with no input', ->
      runs =>
        @output = null
        @runner.onDidWriteToStdout (output) =>
          @output = output
        @runner.run(@command, ['./outputTest.js'], {})

      waitsFor =>
        @output != null
      , "File should execute", 500

      runs =>
        expect(@output).toEqual({ message: 'hello\n' })

    it 'with an input string', ->
      runs =>
        @output = null
        @runner.onDidWriteToStdout (output) =>
          @output = output
        @runner.run(@command, ['./ioTest.js'], {}, 'hello')

      waitsFor =>
        @output != null
      , "File should execute", 500

      runs =>
        expect(@output).toEqual({ message: 'TEST: hello\n' })

    it 'exits', ->
      runs =>
        @exited = false
        @runner.onDidExit =>
          @exited = true
        @runner.run(@command, ['./outputTest.js'], {})

      waitsFor =>
        @exited
      , "Should receive exit callback", 500

    it 'notifies about writing to stderr', ->
      runs =>
        @failedEvent = null
        @runner.onDidWriteToStderr (event) =>
          @failedEvent = event
        @runner.run(@command, ['./throw.js'], {})

      waitsFor =>
        @failedEvent
      , "Should receive failure callback", 500

      runs =>
        expect(@failedEvent.message).toMatch(/kaboom/)

    it 'terminates stdin', ->
      runs =>
        @output = null
        @runner.onDidWriteToStdout (output) =>
          @output = output
        @runner.run(@command, ['./stdinEndTest.js'], {}, 'unused input')

      waitsFor =>
        @output != null
      , "File should execute", 500

      runs =>
        expect(@output).toEqual({ message: 'stdin terminated\n' })
