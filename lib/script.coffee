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

      if not editor?
        console.log("Editor unavailable")
        return

      code = editor.getSelectedText()

      if not code? or not code
        code = editor.getText()

      grammar = editor.getGrammar()

      @lang = grammar.name

      if grammar.name == "Null Grammar"
        console.log("Need to select a language in the lower left or")
        console.log("save the file with an appropriate extension.")
        return

      if ! grammar.name in grammarMap
        console.log("Interpreter not configured for " + @lang)
        console.log("Send a pull request to add support!")
        return

      atom.workspaceView.open(configUri, split: 'right')
      @scriptView.runit(code)
