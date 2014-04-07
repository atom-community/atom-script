ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'
ScriptOptions = require './script-options'

module.exports =
  scriptView: null
  scriptOptionsView: null
  scriptOptions: null

  activate: (state) ->
    @scriptOptions = new ScriptOptions()
    @scriptView = new ScriptView state.scriptViewState, @scriptOptions
    @scriptOptionsView = new ScriptOptionsView @scriptOptions

  deactivate: ->
    @scriptView.close()
    @scriptOptionsView.close()

  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
