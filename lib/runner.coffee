{Emitter, BufferedProcess} = require 'atom'

module.exports =
class Runner
  bufferedProcess: null

  constructor: (@runOptions, @emitter = new Emitter) ->

  run: (command, extraArgs, codeContext) ->
    @startTime = new Date()
    @command = command

    args = @args(codeContext, extraArgs)
    exit = @onExit
    stdout = @stdoutFunc
    stderr = @stderrFunc
    options = @options()

    @bufferedProcess = new BufferedProcess({
      command, args, options, stdout, stderr, exit
    })

    @stdinFunc(@bufferedProcess.process.stdin) if @stdinFunc

    @bufferedProcess.onWillThrowError(@createOnErrorFunc(command))

  stdoutFunc: (output) =>
    @emitter.emit 'did-write-to-stdout', { message: output }

  onDidWriteToStdout: (callback) =>
    @emitter.on 'did-write-to-stdout', callback

  stderrFunc: (output) =>
    @emitter.emit 'did-write-to-stderr', { message: output }

  onDidWriteToStderr: (callback) =>
    @emitter.on 'did-write-to-stderr', callback

  stdinFunc: null

  destroy: ->
    @eitter.dispose()

  getCwd: ->
    cwd = @runOptions.workingDirectory

    workingDirectoryProvided = cwd? and cwd isnt ''
    paths = atom.project.getPaths()
    if not workingDirectoryProvided and paths?.length > 0
      cwd = paths[0]

    cwd

  stop: ->
    if @bufferedProcess?
      @bufferedProcess.kill()
      @bufferedProcess = null

  onExit: (returnCode) =>
    @bufferedProcess = null

    if (atom.config.get 'script.enableExecTime') is true and @startTime
      executionTime = (new Date().getTime() - @startTime.getTime()) / 1000

    @emitter.emit 'did-exit', { executionTime: executionTime, returnCode: returnCode }

  onDidExit: (callback) =>
    @emitter.on 'did-exit', callback

  createOnErrorFunc: (command) =>
    (nodeError) =>
      @bufferedProcess = null
      @emitter.emit 'did-not-run', { command: command }
      @view.showUnableToRunError(command)
      nodeError.handle()

  onDidNotRun: (callback) =>
    @emitter.on 'did-not-run', callback

  options: ->
    cwd: @getCwd()
    env: @runOptions.mergedEnv(process.env)

  args: (codeContext, extraArgs) ->
    args = (@runOptions.cmdArgs.concat extraArgs).concat @runOptions.scriptArgs
    if not @runOptions.cmd? or @runOptions.cmd is ''
      args = codeContext.shebangCommandArgs().concat args

