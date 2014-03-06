grammarMap = require './grammars'
{View, BufferedProcess} = require 'atom'
HeaderView = require './header-view'

# Runs a portion of a script through an interpreter and displays it line by line
module.exports =
class ScriptView extends View
  @bufferedProcess: null

  @content: ->
    # Display layout and outlets
    @div class: 'tool-panel panel panel-bottom padding script', outlet: 'script', tabindex: -1, =>
      @subview 'headerView', new HeaderView()
      @div class: 'panel-body padded output', outlet: 'output'

  initialize: (serializeState) ->
    atom.workspaceView.command "script:close-view", => @close()
    atom.workspaceView.command "script:kill-process", => @stop()

  serialize: ->

  resetView: ->
    # Display window and load message

    # First run, create view
    if not @hasParent()
      atom.workspaceView.prependToBottom(this)

    # Close any existing process and start a new one
    @stop()

    @headerView.title.text("Loading...")
    @headerView.setStatus("start")

    # Get script view ready
    @output.empty()

  close: ->
    # Stop any running process and dismiss window
    @stop()
    if @hasParent() then @detach()

  getlang: (editor) ->
    grammar = editor.getGrammar()
    lang = grammar.name
    return lang

  setup: (editor) ->
    @resetView()
    argSetup = @buildArgs(editor)
    return argSetup

  buildArgs: (editor) ->

    # Get language and filename
    lang = @getlang(editor)
    filename = editor.getTitle()

    # Update header
    @headerView.title.text(lang + " - " + filename)

    err = null
    # Determine if no language is selected
    if lang == "Null Grammar" or lang == "Plain Text"
      err =
        "Please select a language in the lower left or " +
        "save the file with an appropriate extension."

    # Provide them a dialog to submit an issue on GH, prepopulated
    # with their language of choice
    else if ! (lang of grammarMap)
      err =
        "Command not configured for " + lang + "!\n\n" +
        "Add an <a href='https://github.com/rgbkrk/atom-script/issues/" +
        "new?title=Add%20support%20for%20" + lang + "'>issue on GitHub" +
        "</a> or send your own Pull Request"

    if err?
      @displayError(err)
      return false

    [runType, arg] = @getRunType(editor)

    makeargs = grammarMap[lang][runType]

    # argument layout for BufferedProcess
    argSetup = {}

    try
      args = makeargs(arg)

      # Precondition: lang? and lang of grammarMap
      argSetup.command = grammarMap[lang]["command"]
      argSetup.args = args
    catch error
      err = runType + " Runner not available for " + lang + "\n\n" +
            "If it should exist add an " +
            "<a href='https://github.com/rgbkrk/atom-script/issues/" +
            "new?title=Add%20support%20for%20" + lang + "'>issue on GitHub" +
            "</a> or send your own Pull Request"
      @displayError(err)
      return false

    # Return argument build
    return argSetup

  getRunType: (editor) ->
    # Get selected text
    selectedText = editor.getSelectedText()
    filepath = editor.getPath()

    # If no text was selected, either use the file
    # or select ALL the code in the editor

    # Brand new file, text not selected, "select" ALL the text
    if (not selectedText? or not selectedText) and not filepath?
      selectedText = editor.getText()

    # No selected text on a file that does exist, use filepath
    if (not selectedText? or not selectedText) and filepath?
      runType = "File Based"
      arg = filepath
    else
      runType = "Selection Based"
      arg = selectedText

    return [runType, arg]

  displayError: (err) ->
    # Display error and kill process
    @headerView.title.text("Error")
    @display("error", err)
    @stop()

  run: (command, args) ->
    # Default to where the user opened atom
    options =
      cwd: atom.project.getPath()
      env: process.env

    stdout = (output) => @display("stdout", output)
    stderr = (output) => @display("stderr", output)
    exit = (return_code) -> console.log "Exited with #{return_code}"

    # Run process
    @bufferedProcess = new BufferedProcess({command, args, options, stdout, stderr, exit})

  stop: ->
    # Kill existing process if available
    if @bufferedProcess? and @bufferedProcess.process?
      @display("stdout", "^C")
      @bufferedProcess.kill()

  display: (css, line) ->
    # For display
    @output.append("<pre class='line #{css}'>#{line}</pre>")
