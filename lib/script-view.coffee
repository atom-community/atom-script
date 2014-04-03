{View, BufferedProcess} = require 'atom'
HeaderView = require './header-view'
_ = require 'underscore'

AnsiFilter = require 'ansi-to-html'

# Runs a portion of a script through an interpreter and displays it line by line
module.exports =
class ScriptView extends View
  @bufferedProcess: null

  @content: ->
    @div class: 'outer-scriptView', =>
      @subview 'headerView', new HeaderView()
      # Display layout and outlets
      @div class: 'tool-panel panel panel-bottom padding scriptView native-key-bindings', outlet: 'script', tabindex: -1, =>
        @div class: 'panel-body padded output', outlet: 'output'

  initialize: (serializeState) ->
    # Bind commands
    atom.workspaceView.command "script:run", => @start()
    atom.workspaceView.command "script:close-view", => @close()
    atom.workspaceView.command "script:kill-process", => @stop()

    @ansiFilter = new AnsiFilter

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

    langConfig = atom.config.get('script.grammars.' + lang)

    err = null
    # Determine if no language is selected
    if lang == "Null Grammar" or lang == "Plain Text"
      err =
        "Must select a language in the lower left or " +
        "save the file with an appropriate extension."

    # Provide them a dialog to submit an issue on GH, prepopulated
    # with their language of choice
    else if not langConfig?
      err =
        "Command not configured for " + lang + "!\n\n" +
        "Add an <a href='https://github.com/rgbkrk/atom-script/issues/" +
        "new?title=Add%20support%20for%20" + lang + "'>issue on GitHub" +
        "</a> or send your own Pull Request"

    if err?
      @handleError(err)
      return false

    # Precondition: lang? and langConfig?
    info.command = langConfig['command']

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
      flagsType = "Run Flags"
      arg = filepath
    else
      flagsType = "Selection Run Flags"
      arg = selectedText

    args = langConfig[flagsType]

    if not args?
      args = []

    # We assume file/code goes after all the other arguments
    info.args = args.concat [arg]

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
    atom.emit("achievement:unlock", {msg: "Homestar Runner"})

    # Default to where the user opened atom
    options =
      cwd: atom.project.getPath()
      env: process.env

    stdout = (output) => @display("stdout", output)
    stderr = (output) => @display("stderr", output)
    exit = (return_code) =>
      if return_code is 0
        @headerView.setStatus("stop")
      else
        @headerView.setStatus("err")
      console.log "Exited with #{return_code}"

    # Run process
    @bufferedProcess = new BufferedProcess({command, args, options,
                                            stdout, stderr, exit})
    @bufferedProcess.process.on('error', (node_error) =>
      @output.append("<h1>Unable to run</h1>")
      @output.append("<pre>#{_.escape(command)}</pre>")
      @output.append("<h2>Is it on your path?</h2>")
      @output.append("<pre>PATH: #{_.escape(process.env.PATH)}</pre>")

    )

  stop: ->
    # Kill existing process if available
    if @bufferedProcess? and @bufferedProcess.process?
      @display("stdout", "^C")
      @headerView.setStatus("kill")
      @bufferedProcess.kill()

  display: (css, line) ->

    line = _.escape(line)
    line = @ansiFilter.toHtml(line)

    @output.append("<pre class='line #{css}'>#{line}</pre>")
