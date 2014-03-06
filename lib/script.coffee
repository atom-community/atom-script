ScriptView = require './script-view'

module.exports =
  scriptView: null

  activate: (state) ->
    @scriptView = new ScriptView(state.scriptViewState)

    atom.workspaceView.command "script:run", => @start()

  start: ->
    # Get current editor
    editor = atom.workspace.getActiveEditor()

    # No editor available, do nothing
    if not editor?
      return

    argSetup = @scriptView.setup(editor)

    if argSetup then @scriptView.run(argSetup.command, argSetup.args)

  deactivate: ->
    @scriptView.destroy()

  serialize: ->
    scriptViewState: @scriptViewState.serialize()
