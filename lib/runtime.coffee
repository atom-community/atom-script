CommandContext = require './command-context'

_ = require 'underscore'

{Emitter} = require 'atom'

module.exports =
class Runtime
  observers: []

  # Public: Initializes a new {Runtime} instance
  #
  # This class is responsible for properly configuring {Runner}
  constructor: (@runner, @codeContextBuilder, @observers = [], @emitter = new Emitter) ->
    @scriptOptions = @runner.scriptOptions
    _.each @observers, (observer) => observer.observe(@)

  # Public: Adds a new observer and asks it to listen for {Runner} events
  #
  # An observer should have two methods:
  # * `observe(runtime)` - in which you can subscribe to {Runtime} events
  # (see {ViewRuntimeObserver} for what you are expected to handle)
  # * `destroy` - where you can do your cleanup
  addObserver: (observer) ->
    @observers.push(observer)
    observer.observe(@)

  # Public: disposes dependencies
  #
  # This should be called when you no longer need to use this class
  destroy: ->
    @stop()
    @runner.destroy()
    _.each @observers, (observer) -> observer.destroy()
    @emitter.dispose()
    @codeContextBuilder.destroy()

  # Public: Executes code
  #
  # argType (Optional) - {String} One of the three:
  # * "Selection Based" (default)
  # * "Line Number Based"
  # * "File Based"
  # input (Optional) - {String} that'll be provided to the `stdin` of the new process
  execute: (argType = "Selection Based", input = null, options = null) ->
    @stop() if atom.config.get 'script.stopOnRerun'
    @emitter.emit 'start'

    codeContext = @codeContextBuilder.buildCodeContext(atom.workspace.getActiveTextEditor(), argType)

    # In the future we could handle a runner without the language being part
    # of the grammar map, using the options runner
    return unless codeContext?.lang?

    executionOptions = if options then options else @scriptOptions
    commandContext = CommandContext.build(@, executionOptions, codeContext)

    return unless commandContext

    if commandContext.workingDirectory?
      executionOptions.workingDirectory = commandContext.workingDirectory

    @emitter.emit 'did-context-create',
      lang: codeContext.lang
      filename: codeContext.filename
      lineNumber: codeContext.lineNumber

    @runner.scriptOptions = executionOptions
    @runner.run(commandContext.command, commandContext.args, codeContext, input)
    @emitter.emit 'started', commandContext

  # Public: stops execution of the current fork
  stop: ->
    @emitter.emit 'stop'
    @runner.stop()
    @emitter.emit 'stopped'

  # Public: Dispatched when the execution is starting
  onStart: (callback) ->
    @emitter.on 'start', callback

  # Public: Dispatched when the execution is started
  onStarted: (callback) ->
    @emitter.on 'started', callback

  # Public: Dispatched when the execution is stopping
  onStop: (callback) ->
    @emitter.on 'stop', callback

  # Public: Dispatched when the execution is stopped
  onStopped: (callback) ->
    @emitter.on 'stopped', callback

  # Public: Dispatched when the language is not specified
  onDidNotSpecifyLanguage: (callback) ->
    @codeContextBuilder.onDidNotSpecifyLanguage callback

  # Public: Dispatched when the language is not supported
  # lang  - {String} with the language name
  onDidNotSupportLanguage: (callback) ->
    @codeContextBuilder.onDidNotSupportLanguage callback

  # Public: Dispatched when the mode is not supported
  # lang  - {String} with the language name
  # argType  - {String} with the run mode specified
  onDidNotSupportMode: (callback) ->
    @emitter.on 'did-not-support-mode', callback

  # Public: Dispatched when building run arguments resulted in an error
  # error - {Error}
  onDidNotBuildArgs: (callback) ->
    @emitter.on 'did-not-build-args', callback

  # Public: Dispatched when the {CodeContext} is successfully created
  # lang  - {String} with the language name
  # filename  - {String} with the filename
  # lineNumber  - {Number} with the line number (may be null)
  onDidContextCreate: (callback) ->
    @emitter.on 'did-context-create', callback

  # Public: Dispatched when the process you run writes something to stdout
  # message - {String} with the output
  onDidWriteToStdout: (callback) ->
    @runner.onDidWriteToStdout callback

  # Public: Dispatched when the process you run writes something to stderr
  # message - {String} with the output
  onDidWriteToStderr: (callback) ->
    @runner.onDidWriteToStderr callback

  # Public: Dispatched when the process you run exits
  # returnCode  - {Number} with the process' exit code
  # executionTime  - {Number} with the process' exit code
  onDidExit: (callback) ->
    @runner.onDidExit callback

  # Public: Dispatched when the code you run did not manage to run
  # command - {String} with the run command
  onDidNotRun: (callback) ->
    @runner.onDidNotRun callback

  modeNotSupported: (argType, lang) ->
    @emitter.emit 'did-not-support-mode', { argType, lang }

  didNotBuildArgs: (error) ->
    @emitter.emit 'did-not-build-args', { error: error }
