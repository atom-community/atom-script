CommandContext = require './command-context'

_ = require 'underscore'

module.exports =
class Runtime
  runner: null
  codeContextBuilder: null
  formatters: []
  scriptView: null

  # Public: Initializes a new {Runtime} instance
  #
  # This class is responsible for properly configuring {Runner}
  constructor: (@runner, @codeContextBuilder, @formatters, @scriptView) ->
    @scriptOptions = @runner.scriptOptions
    _.each @formatters, (formatter) => formatter.listen(@runner)

  # Public: Adds a new formatter and asks it to listen for {Runner} events
  addFormatter: (formatter) ->
    @formatters.push(formatter)
    formatter.listen(@runner)

  # Public: disposes dependencies
  #
  # This should be called when you no longer need to use this class
  destroy: ->
    @stop()
    @runner.destroy()
    _.each @formatters, _.destroy

  # Public: Executes code
  #
  # argType (Optional) - {String} One of the three:
  # * "Selection Based" (default)
  # * "Line Number Based"
  # * "File Based"
  # input (Optional) - {String} that'll be provided to the `stdin` of the new process
  execute: (argType = "Selection Based", input = null) ->
    @scriptView.resetView()
    codeContext = @codeContextBuilder.buildCodeContext(atom.workspace.getActiveTextEditor(), argType)

    # In the future we could handle a runner without the language being part
    # of the grammar map, using the options runner
    return unless codeContext.lang?

    commandContext = CommandContext.build(@scriptView, @scriptOptions, codeContext)

    return unless commandContext

    # Update header to show the lang and file name
    if codeContext.argType is 'Line Number Based'
      @scriptView.setHeaderTitle "#{codeContext.lang} - #{codeContext.fileColonLine(false)}"
    else
      @scriptView.setHeaderTitle "#{codeContext.lang} - #{codeContext.filename}"

    @runner.run(commandContext.command, commandContext.args, codeContext, input)

  # Public: stops execution of the current fork
  stop: ->
    @scriptView.stop()
    @runner.stop()
