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

    atom.workspaceView.on 'core:cancel core:close', (event) =>
      @scriptView?.close()
      @scriptOptionsView?.close()

  deactivate: ->
    @scriptView.close()
    @scriptOptionsView.close()

    atom.workspaceView.off 'core:cancel core:close'

  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
