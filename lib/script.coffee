ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'
ScriptOptions = require './script-options'

module.exports =
  scriptView: null
  scriptOptionsView: null
  scriptOptions: null

  activate: (state) ->
    scriptOptions = new ScriptOptions()
    @scriptView = new ScriptView(state.scriptViewState, scriptOptions)
    @scriptOptionsView = new ScriptOptionsView(state.scriptOptionsViewState, scriptOptions)

  deactivate: ->
    @scriptView.close()
    @scriptOptionsView.close()
    @scriptOptions = null

  serialize: ->
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
