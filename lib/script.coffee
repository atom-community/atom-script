ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'

module.exports =
  scriptView: null
  scriptOptionsView: null

  activate: (state) ->
    @scriptView = new ScriptView(state.scriptViewState)
    @scriptOptionsView = new ScriptOptionsView(state.scriptOptionsViewState)

  deactivate: ->
    @scriptView.close()
    @scriptOptionsView.close()

  serialize: ->
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
