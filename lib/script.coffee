ScriptView = require './script-view'
ScriptOptionsView = require './script-options-view'
ScriptOptions = require './script-options'

module.exports =
  configDefaults:
    path_prefix: null

  scriptView: null
  scriptOptionsView: null
  scriptOptions: null

  activate: (state) ->
    # TODO: Do we have to set a default for empty?
    atom.config.setDefaults "script",
      path_prefix: null

    @scriptOptions = new ScriptOptions()
    @scriptView = new ScriptView(state.scriptViewState, @scriptOptions)
    @scriptOptionsView = new ScriptOptionsView(@scriptOptions)

  deactivate: ->
    @scriptView.close()
    @scriptOptionsView.close()

  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
