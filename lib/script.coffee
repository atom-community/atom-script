GrammarUtils = require './grammar-utils'
Runner = require './runner'
ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'
ScriptOptions = require './script-options'
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
    @scriptOptions = new ScriptOptions()
    @runner = new Runner(@scriptOptions)
    @scriptView = new ScriptView state.scriptViewState, @scriptOptions, @runner
    @scriptOptionsView = new ScriptOptionsView @scriptOptions
    @formatter = new ViewFormatter(@runner, @scriptView)

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @closeScriptViewAndStopRunner()
      'core:close': => @closeScriptViewAndStopRunner()
      'script:close-view': => @closeScriptViewAndStopRunner()
      'script:copy-run-results': => @scriptView.copyResults()
      'script:kill-process': => @killProcess()
      'script:run-by-line-number': => @scriptView.start('Line Number Based')
      'script:run': => @scriptView.start('Selection Based')

  deactivate: ->
    GrammarUtils.deleteTempFiles()
    @scriptView.close()
    @scriptOptionsView.close()
    @subscriptions.dispose()

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
