ScriptView = require './script-view'

module.exports =
  scriptView: null

  activate: (state) ->
    @scriptView = new ScriptView(state.scriptViewState)

  deactivate: ->
    @scriptView.destroy()

  serialize: ->
    scriptViewState: @scriptViewState.serialize()
