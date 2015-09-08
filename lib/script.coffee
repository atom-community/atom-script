CodeContextBuilder = require './code-context-builder'
CommandContext = require './command-context'
GrammarUtils = require './grammar-utils'
Runner = require './runner'
ScriptOptions = require './script-options'
ScriptOptionsView = require './script-options-view'
ScriptView = require './script-view'
ViewFormatter = require './view-formatter'

{CompositeDisposable} = require 'atom'

module.exports =
  config:
    enableExecTime:
      title: 'Output the time it took to execute the script'
      type: 'boolean'
      default: true
    escapeConsoleOutput:
      title: 'HTML escape console output'
      type: 'boolean'
      default: true
    scrollWithOutput:
      title: 'Scroll with output'
      type: 'boolean'
      default: true
  scriptView: null
  scriptOptionsView: null
  scriptOptions: null

  activate: (state) ->
    @scriptView = new ScriptView state.scriptViewState
    @scriptOptions = new ScriptOptions()
    @scriptOptionsView = new ScriptOptionsView @scriptOptions

    @runner = new Runner(@scriptOptions)
    @formatter = new ViewFormatter(@runner, @scriptView)
    @codeContextBuilder = new CodeContextBuilder(@scriptView)

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @closeScriptViewAndStopRunner()
      'core:close': => @closeScriptViewAndStopRunner()
      'script:close-view': => @closeScriptViewAndStopRunner()
      'script:copy-run-results': => @scriptView.copyResults()
      'script:kill-process': => @killProcess()
      'script:run-by-line-number': => @start(@runner, 'Line Number Based')
      'script:run': => @start(@runner, 'Selection Based')

  deactivate: ->
    GrammarUtils.deleteTempFiles()
    @scriptView.close()
    @scriptOptionsView.close()
    @subscriptions.dispose()

  start: (runner, argType, input = null) ->
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

    runner.run(commandContext.command, commandContext.args, codeContext, input) if commandContext

  closeScriptViewAndStopRunner: ->
    @scriptView.close()
    @runner.stop()

  killProcess: ->
    @scriptView.stop()
    @runner.stop()


  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
