ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'
ScriptOptions = require './script-options'
GrammarUtils = require './grammar-utils'

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
    @scriptView = new ScriptView state.scriptViewState, @scriptOptions
    @scriptOptionsView = new ScriptOptionsView @scriptOptions

    atom.workspaceView.on 'core:cancel core:close', (event) =>
      @scriptView?.close()
      @scriptOptionsView?.close()

  deactivate: ->
    GrammarUtils.deleteTempFiles()
    @scriptView.close()
    @scriptOptionsView.close()

    atom.workspaceView.off 'core:cancel core:close'

  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
