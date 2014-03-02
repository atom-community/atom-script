ScriptView = require './script-view'

configUri = "atom://script"

# The grammarMap maps Atom Grammar names to the interpreter used by that language
# As well as any special setup for arguments.
grammarMap =
  CoffeeScript:
    interpreter: "coffee"
    makeargs: (code) -> ['-e', code]
  Python:
    interpreter: "python"
    makeargs: (code) -> ['-c', code]
  JavaScript:
    interpreter: "node"
    makeargs: (code) -> ['-e', code]
  Ruby:
    interpreter: "ruby"
    makeargs: (code) -> ['-e', code]

module.exports =

  activate: ->
    atom.project.registerOpener (uri) =>

      if @lang? and @lang of grammarMap
        interpreter = grammarMap[@lang]["interpreter"]
        makeargs = grammarMap[@lang]["makeargs"]

        @scriptView = new ScriptView(interpreter, makeargs) if uri is configUri

    atom.workspaceView.command "script:run-selection", =>

      editor = atom.workspace.getActiveEditor()

      if not editor?
        console.log("Editor unavailable")
        return

      # Get selected text
      code = editor.getSelectedText()
      # If no text was selected, select ALL the code in the editor
      if not code? or not code
        code = editor.getText()

      grammar = editor.getGrammar()
      @lang = grammar.name

      # Null Grammar is the name of the "Plain text" language
      if grammar.name == "Null Grammar"
        console.log("Need to select a language in the lower left or")
        console.log("save the file with an appropriate extension.")
        return

      # TODO: Provide them a dialog to submit an issue on GH, prepopulated
      #       with their language of choice
      if ! (grammar.name of grammarMap)
        console.log("Interpreter not configured for " + @lang)
        console.log("Send a pull request to add support!")
        return

      atom.workspaceView.open(configUri, split: 'right')
      @scriptView.runit(code)
