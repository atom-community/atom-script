ScriptView = require './script-view'

configUri = "atom://script"

grammarMap =
  CoffeeScript:
    interpreter: "coffee"
    makeargs: (code) -> ['-e', code]

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

      console.log("Here we go")

      grammar = editor.getGrammar()
      lang = grammar.name

      interpreter = grammarMap[lang]["interpreter"]
      makeargs = grammarMap[lang]["makeargs"]

      @scriptView = new ScriptView(interpreter, makeargs)

      atom.workspaceView.open(configUri, split: 'right')
      @scriptView.runit(code)
