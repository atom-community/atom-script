{Emitter, BufferedProcess} = require 'atom'
fs = require 'fs'
path = require 'path'

module.exports =
class Runner
  bufferedProcess: null

  # Public: Creates a Runner instance
  #
  # * `scriptOptions` a {ScriptOptions} object instance
  # * `emitter` Atom's {Emitter} instance. You probably don't need to overwrite it
  constructor: (@scriptOptions, @emitter = new Emitter) ->

  run: (command, extraArgs, codeContext, inputString = null) ->
    @startTime = new Date()

    args = @args(codeContext, extraArgs)
    options = @options()
    stdout = @stdoutFunc
    stderr = @stderrFunc
    exit = @onExit

    @bufferedProcess = new BufferedProcess({
      command, args, options, stdout, stderr, exit
    })

    if inputString
      @bufferedProcess.process.stdin.write(inputString)
      @bufferedProcess.process.stdin.end()

    @bufferedProcess.onWillThrowError(@createOnErrorFunc(command))

  stdoutFunc: (output) =>
    @emitter.emit 'did-write-to-stdout', { message: output }

  onDidWriteToStdout: (callback) ->
    @emitter.on 'did-write-to-stdout', callback

  stderrFunc: (output) =>
    @emitter.emit 'did-write-to-stderr', { message: output }

  onDidWriteToStderr: (callback) ->
    @emitter.on 'did-write-to-stderr', callback

  destroy: ->
    @emitter.dispose()

  getCwd: ->
    cwd = @scriptOptions.workingDirectory

    workingDirectoryProvided = cwd? and cwd isnt ''
    paths = atom.project.getPaths()
    if not workingDirectoryProvided and paths?.length > 0
      try
        cwd = if fs.statSync(paths[0]).isDirectory() then paths[0] else path.join(paths[0], '..')
    
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

  onDidExit: (callback) ->
    @emitter.on 'did-exit', callback

  createOnErrorFunc: (command) =>
    (nodeError) =>
      @bufferedProcess = null
      @emitter.emit 'did-not-run', { command: command }
      nodeError.handle()

  onDidNotRun: (callback) ->
    @emitter.on 'did-not-run', callback

  options: ->
    cwd: @getCwd()
    env: @scriptOptions.mergedEnv(process.env)

  fillVarsInArg: (arg, codeContext, project_path) ->
    if codeContext.filepath?
      arg = arg.replace(/{FILE_ACTIVE}/g, codeContext.filepath)
      arg = arg.replace(/{FILE_ACTIVE_PATH}/g, path.join(codeContext.filepath, '..'))
    if codeContext.filename?
      arg = arg.replace(/{FILE_ACTIVE_NAME}/g, codeContext.filename)
      arg = arg.replace(/{FILE_ACTIVE_NAME_BASE}/g, path.join(codeContext.filename, '..'))
    if project_path?
      arg = arg.replace(/{PROJECT_PATH}/g, project_path)
    
    arg

  args: (codeContext, extraArgs) ->
    args = (@scriptOptions.cmdArgs.concat extraArgs).concat @scriptOptions.scriptArgs
    project_path = ''
    paths = atom.project.getPaths()
    if paths.length > 0
      fs.stat(paths[0], (err, stats) ->
        if !err
          project_path = if stats.isDirectory() then paths[0] else path.join(paths[0], '..')
      )
    
    args = (@fillVarsInArg arg, codeContext, project_path for arg in args)
    
    if not @scriptOptions.cmd? or @scriptOptions.cmd is ''
      args = codeContext.shebangCommandArgs().concat args
    args
