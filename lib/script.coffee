ScriptView = require './script-view'

configUri = "atom://script"

module.exports =

  activate: ->
    atom.project.registerOpener (uri) =>

      interpreter = "coffee"
      makeargs = (code) -> ['-e', code]

      @scriptView = new ScriptView(interpreter, makeargs) if uri is configUri

    atom.workspaceView.command "script:run-selection", =>
      editor = atom.workspace.getActiveEditor()
      code = editor.getSelectedText()

      if ! code?
        return

      atom.workspaceView.open(configUri, split: 'right')
      @scriptView.runit(code)
