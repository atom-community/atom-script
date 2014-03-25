ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'

module.exports =
  scriptView: null
  scriptOptionsView: null
  scriptOptions: null

  activate: (state) ->
    @scriptView = new ScriptView(state.scriptViewState)
    @scriptOptionsView = new ScriptOptionsView(state.scriptOptionsViewState)
    @scriptOptions = new ScriptOptions()

  deactivate: ->
    @scriptView.close()
    @scriptOptionsView.close()
    @scriptOptions = null

  serialize: ->
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
