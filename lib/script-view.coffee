grammarMap = require './grammars'
{View, BufferedProcess} = require 'atom'

# Runs a portion of a script through an interpreter and displays it line by line
module.exports =
class ScriptView extends View
  @bufferedProcess: null
  @lang: null
  @code: null
  @filename: null

  @content: ->
    # Display layout and outlets
    @div class: 'tool-panel panel panel-bottom padding script', outlet: 'script', tabindex: -1, =>
      @div class: 'panel-heading padded heading', outlet: 'heading'
      @div class: 'panel-body padded output', outlet: 'output'

  initialize: (serializeState) ->
    # Bind commands
    atom.workspaceView.command "script:run", => @show()
    atom.workspaceView.command "script:close-view", => @close()
    atom.workspaceView.command "script:kill-process", => @stop()

  serialize: ->

  destroy: ->
    # Stop the running process (if necessary) and dismiss window
    @stop()
    @detach()

  show: ->
    # Display window and load message

    # First run, create view
    if not @hasParent()
      atom.workspaceView.prependToBottom(this)

    @heading.text("Loading...")
    # Close any existing process and start a new one
    @stop()
    @output.empty()

    @start()

  close: ->
    # Dismiss window and stop any running process
    if @hasParent()
      @destroy()

  start: ->
    # Get current editor
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @setup(editor)

  setup: (editor) ->
    # Get selected text
    @code = editor.getSelectedText()
    # If no text was selected, select ALL the code in the editor
    if not @code? or not @code
      # TODO: Switch to full path mode
      #@filename = editor.getPath()
      @code = editor.getText()

    # Get language and filename
    grammar = editor.getGrammar()
    @lang = grammar.name
    @filename = editor.getTitle()

    # Determine if no language is selected
    if grammar.name == "Null Grammar" or grammar.name == "Plain Text"
      err =
        "Must select a language in the lower left or " +
        "save the file with an appropriate extension."
      @handleError(err)
      return

    # Provide them a dialog to submit an issue on GH, prepopulated
    # with their language of choice
    else if ! (grammar.name of grammarMap)
      err =
        "Command not configured for " + @lang + "!\n\n" +
        "Add an <a href='https://github.com/rgbkrk/atom-script/issues/" +
        "new?title=Add%20support%20for%20" + @lang + "'>issue on GitHub" +
        "</a> or send your own Pull Request"
      @handleError(err)
      return

    @run()

  handleError: (err) ->
    # Display error and kill process
    @heading.text("Error")
    @display("error", err)
    @stop()

  run: ->
    # Precondition: @lang? and @lang of grammarMap
    command = grammarMap[@lang]["command"]
    makeargs = grammarMap[@lang]["bySelectionArgs"]

    args = makeargs(@code)

    # Default to where the user opened atom
    options =
      cwd: atom.project.getPath()
      env: process.env

    # Set up process and output display
    @heading.text(@lang + " - " + @filename)
    stdout = (output) => @display("stdout", output)
    stderr = (output) => @display("stderr", output)
    exit = (return_code) -> console.log "Exited with #{return_code}"

    # Run process
    @bufferedProcess = new BufferedProcess({command, args, options, stdout, stderr, exit})

  stop: ->
    # Kill existing process
    @bufferedProcess.kill() if @bufferedProcess? and @bufferedProcess.process?

  display: (css, line) ->
    # For display
    @output.append("<pre class='line #{css}'>#{line}</pre>")
