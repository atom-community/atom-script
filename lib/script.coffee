GrammarUtils = require './grammar-utils'
Runner = require './runner'
ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'
ScriptOptions = require './script-options'
ViewFormatter = require './view-formatter'

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

  deactivate: ->
    GrammarUtils.deleteTempFiles()
    @scriptView.close()
    @scriptOptionsView.close()

  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
