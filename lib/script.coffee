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
    atom.workspaceView.command "script:run-selection", => @show()

    atom.project.registerOpener (uri) =>

      if @lang? and @lang of grammarMap
        interpreter = grammarMap[@lang]["interpreter"]
        makeargs = grammarMap[@lang]["makeargs"]

      @scriptView = new ScriptView(interpreter, makeargs) if uri is configUri

  show: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    # Get selected text
    code = editor.getSelectedText()
    # If no text was selected, select ALL the code in the editor
    if not code? or not code
      code = editor.getText()

    grammar = editor.getGrammar()
    @lang = grammar.name

    # Set up errors
    err = null;

    # Determine if no language is selected
    if grammar.name == "Null Grammar" or grammar.name == "Plain Text"
      err =
        "Must select a language in the lower left or " +
        "save the file with an appropriate extension."

    # TODO: Provide them a dialog to submit an issue on GH, prepopulated
    #       with their language of choice
    else if ! (grammar.name of grammarMap)
      err =
        "Interpreter not configured for " + @lang + "\n" +
        "Create an issue or send a PR at https://github.com/rgbkrk/atom-script to add support"

    atom.workspaceView.open(configUri, split: 'right').done (scriptView) ->
      if scriptView instanceof ScriptView
        scriptView.runit(err, code)
