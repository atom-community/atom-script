ScriptView = require './script-view'
grammarMap = require './grammars'

configUri = "atom://script"

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
        "Interpreter not configured for " + @lang + "!\n\n" +
        "Add an <a href='https://github.com/rgbkrk/atom-script/issues/" +
        "new?title=Add%20support%20for%20" + @lang + "'>issue on GitHub" +
        "</a> or send your own Pull Request"

    atom.workspaceView.open(configUri, split: 'right').done (scriptView) ->
      if scriptView instanceof ScriptView
        scriptView.runit(err, code)
