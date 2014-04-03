ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'
ScriptOptions = require './script-options'

module.exports =
  scriptView: null
  scriptOptionsView: null

  activate: (state) ->
    @scriptView = new ScriptView(state.scriptViewState, new ScriptOptions())
    @scriptOptionsView = new ScriptOptionsView(new ScriptOptions())

  deactivate: ->
    @scriptView.close()
    @scriptOptionsView.close()

  serialize: ->
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
