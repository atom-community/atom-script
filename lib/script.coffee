ScriptView = require './script-view'

configUri = "atom://script"

grammarMap =
  CoffeeScript:
    interpreter: "coffee"
    makeargs: (code) -> ['-e', code]
  Python:
    interpreter: "python"
    makeargs: (code) -> ['-c', code]

module.exports =

  activate: ->
    atom.project.registerOpener (uri) =>

      interpreter = grammarMap[@lang]["interpreter"]
      makeargs = grammarMap[@lang]["makeargs"]

      @scriptView = new ScriptView(interpreter, makeargs) if uri is configUri

    atom.workspaceView.command "script:run-selection", =>
      editor = atom.workspace.getActiveEditor()
      code = editor.getSelectedText()

      if ! code?
        return

      if ! editor?
        console.log("Where's my bloody editor?")
        return

      grammar = editor.getGrammar()

      @lang = grammar.name

      console.log("Here we go")

      atom.workspaceView.open(configUri, split: 'right')
      @scriptView.runit(code)
