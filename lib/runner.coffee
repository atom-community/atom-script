{Emitter, BufferedProcess} = require 'atom'

module.exports =
class Runner
  bufferedProcess: null

  # Public: Creates a Runner instance
  #
  # * `runOptions` a {ScriptOptions} object instance
  # * `inputProvider` An {Object} with `write(Readable Stream)` method
  # * `emitter` Atom's {Emitter} instance. You probably don't need to overwrite it
  constructor: (@runOptions, @inputProvider = null, @emitter = new Emitter) ->

  run: (command, extraArgs, codeContext) ->
    @startTime = new Date()

    @bufferedProcess = new BufferedProcess({
      command,
      @args(codeContext, extraArgs),
      @options(),
      @stdoutFunc,
      @stderrFunc,
      @onExit
    })

    if @inputProvider
      @inputProvider.write(@bufferedProcess.process.stdin)

    @bufferedProcess.onWillThrowError(@createOnErrorFunc(command))

  stdoutFunc: (output) =>
    @emitter.emit 'did-write-to-stdout', { message: output }

  onDidWriteToStdout: (callback) =>
    @emitter.on 'did-write-to-stdout', callback

  stderrFunc: (output) =>
    @emitter.emit 'did-write-to-stderr', { message: output }

  onDidWriteToStderr: (callback) =>
    @emitter.on 'did-write-to-stderr', callback

  destroy: ->
    @emitter.dispose()

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
    args
