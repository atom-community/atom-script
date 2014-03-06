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
    # Bind commands
    atom.workspaceView.command "script:run", => @start()
    atom.workspaceView.command "script:close-view", => @close()
    atom.workspaceView.command "script:kill-process", => @stop()

  serialize: ->

  start: ->
    # Get current editor
    editor = atom.workspace.getActiveEditor()

    # No editor available, do nothing
    if not editor?
      return

    @resetView()
    info = @setup(editor)
    if info then @run(info.command, info.args)

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
    # Info object
    info = {}

    # Get language
    lang = @getlang(editor)

    err = null
    # Determine if no language is selected
    if lang == "Null Grammar" or lang == "Plain Text"
      err =
        "Must select a language in the lower left or " +
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
      @handleError(err)
      return false

    # Precondition: lang? and lang of grammarMap
    info.command = grammarMap[lang]["command"]

    filename = editor.getTitle()

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
      argType = "File Based"
      arg = filepath
    else
      argType = "Selection Based"
      arg = selectedText

    makeargs = grammarMap[lang][argType]

    try
      args = makeargs(arg)
      info.args = args
    catch error
      err = argType + " Runner not available for " + lang + "\n\n" +
            "If it should exist add an " +
            "<a href='https://github.com/rgbkrk/atom-script/issues/" +
            "new?title=Add%20support%20for%20" + lang + "'>issue on GitHub" +
            "</a> or send your own Pull Request"
      @handleError(err)
      return false

    # Update header
    @headerView.title.text(lang + " - " + filename)
    # Return setup information
    return info

  handleError: (err) ->
    # Display error and kill process
    @headerView.title.text("Error")
    @headerView.setStatus("err")
    @display("error", err)
    @stop()

  run: (command, args) ->
    # Default to where the user opened atom
    options =
      cwd: atom.project.getPath()
      env: process.env

    stdout = (output) => @display("stdout", output)
    stderr = (output) => @display("stderr", output)
    exit = (return_code) =>
      if return_code is 0 then @headerView.setStatus("stop") else @headerView.setStatus("err")
      console.log "Exited with #{return_code}"

    # Run process
    @bufferedProcess = new BufferedProcess({command, args, options, stdout, stderr, exit})

  stop: ->
    # Kill existing process if available
    if @bufferedProcess? and @bufferedProcess.process?
      @display("stdout", "^C")
      @headerView.setStatus("err")
      @bufferedProcess.kill()

  display: (css, line) ->
    # For display
    @output.append("<pre class='line #{css}'>#{line}</pre>")
