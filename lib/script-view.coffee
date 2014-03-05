grammarMap = require './grammars'
{View, BufferedProcess} = require 'atom'

# Runs a portion of a script through an interpreter and displays it line by line
module.exports =
class ScriptView extends View
  @bufferedProcess: null
  @lang: null
  @code: null
  @err: null
  @filename: null

  @content: ->
    @div class: 'tool-panel panel panel-bottom padding script', outlet: 'script', tabindex: -1, =>
      @div class: 'panel-heading padded heading', outlet: 'heading'
      @div class: 'panel-body padded output', outlet: 'output'

  initialize: (serializeState) ->
    atom.workspaceView.command "script:run", => @show()
    atom.workspaceView.command "script:close-view", => @close()
    atom.workspaceView.command "script:kill-process", => @stop()

  serialize: ->

  destroy: ->
    @detach()
    @stop()

  show: ->
    if not @hasParent()
      atom.workspaceView.prependToBottom(this)
    @heading.text("Loading...")
    @output.empty()
    @stop()
    @start()

  close: ->
    if @hasParent()
      @detach()
      @stop()

  start: ->
    @check()

    if @err?
      @display("Error", "error", @err)
      @err = null
      @stop()
    else
      if @lang? and @lang of grammarMap
          interpreter = grammarMap[@lang]["interpreter"]
          makeargs = grammarMap[@lang]["makeargs"]

      command = interpreter
      args = makeargs(@code)

      # Default to where the user opened atom
      options =
        cwd: atom.project.getPath()
        env: process.env

      stdout = (output) => @display(@lang + " - " + @filename, "stdout", output)
      stderr = (output) => @display(@lang + " - " + @filename, "stderr", output)
      exit = (return_code) -> console.log("Exited with #{return_code}")

      @bufferedProcess = new BufferedProcess({command, args, options, stdout, stderr, exit})

  stop: ->
    @bufferedProcess.kill() if @bufferedProcess? and @bufferedProcess.process?

  check: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    # Get selected text
    @code = editor.getSelectedText()
    # If no text was selected, select ALL the code in the editor
    if not @code? or not @code
      @code = editor.getText()

    grammar = editor.getGrammar()
    @lang = grammar.name
    @filename = editor.getTitle()

    # Determine if no language is selected
    if grammar.name == "Null Grammar" or grammar.name == "Plain Text"
      @err =
        "Must select a language in the lower left or " +
        "save the file with an appropriate extension."

    # Provide them a dialog to submit an issue on GH, prepopulated
    # with their language of choice
    else if ! (grammar.name of grammarMap)
      @err =
        "Interpreter not configured for " + @lang + "!\n\n" +
        "Add an <a href='https://github.com/rgbkrk/atom-script/issues/" +
        "new?title=Add%20support%20for%20" + @lang + "'>issue on GitHub" +
        "</a> or send your own Pull Request"

  display: (title, css, line)->
    @heading.text(title)
    @output.append("<pre class='line #{css}'>#{line}</pre>")
