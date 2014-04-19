grammarMap = require './grammars'
{View, BufferedProcess, $$} = require 'atom'
HeaderView = require './header-view'
ScriptOptionsView = require './script-options-view'
AnsiFilter = require 'ansi-to-html'
_ = require 'underscore'

# Runs a portion of a script through an interpreter and displays it line by line
module.exports =
class ScriptView extends View
  @bufferedProcess: null

  @content: ->
    @div =>
      @subview 'headerView', new HeaderView()

      # Display layout and outlets
      css = 'tool-panel panel panel-bottom padding script-view
        native-key-bindings'
      @div class: css, outlet: 'script', tabindex: -1, =>
        @div class: 'panel-body padded output', outlet: 'output'

  initialize: (serializeState, @runOptions) ->
    # Bind commands
    atom.workspaceView.command 'script:run', => @start()
    atom.workspaceView.command 'script:close-view', => @close()
    atom.workspaceView.command 'script:kill-process', => @stop()

    @ansiFilter = new AnsiFilter

  serialize: ->

  updateOptions: (event) -> @runOptions = event.runOptions

  start: ->
    # Get current editor
    editor = atom.workspace.getActiveEditor()

    # No editor available, do nothing
    return unless editor?

    @resetView()
    commandContext = @setup editor
    @run commandContext.command, commandContext.args if commandContext

  resetView: (title = 'Loading...') ->
    # Display window and load message

    # First run, create view
    atom.workspaceView.prependToBottom this unless @hasParent()

    # Close any existing process and start a new one
    @stop()

    @headerView.title.text title
    @headerView.setStatus 'start'

    # Get script view ready
    @output.empty()

  close: ->
    # Stop any running process and dismiss window
    @stop()
    @detach() if @hasParent()

  getLang: (editor) -> editor.getGrammar().name

  setup: (editor) ->
    # Store information about the run, including language
    commandContext = {}

    # Get language
    lang = @getLang editor
    err = null

    # Determine if no language is selected.
    if lang is 'Null Grammar' or lang is 'Plain Text'
      err = $$ ->
        @p 'You must select a language in the lower left, or save the file
          with an appropriate extension.'

    # Provide them a dialog to submit an issue on GH, prepopulated with their
    # language of choice.
    else if not (lang of grammarMap)
      err = $$ ->
        @p class: 'block', "Command not configured for #{lang}!"
        @p class: 'block', =>
          @text 'Add an '
          @a href: "https://github.com/rgbkrk/atom-script/issues/\
            new?title=Add%20support%20for%20#{lang}", 'issue on GitHub'
          @text ' or send your own Pull Request.'

    if err?
      @handleError(err)
      return false

    filename = editor.getTitle()
    filepath = editor.getPath()
    selection = editor.getSelection()

    # No selected text on a file that does exist, use filepath
    if selection.isEmpty() and filepath?
      argType = 'File Based'
      arg = filepath
      editor.save()
    else
      argType = 'Selection Based'
      # If the selection was empty "select" ALL the text
      # This allows us to run on new files
      if selection.isEmpty()
         arg = editor.getText()
      else
         arg = selection.getText()

    try
      if not @runOptions.cmd? or @runOptions.cmd is ''
        # Precondition: lang? and lang of grammarMap
        commandContext.command = grammarMap[lang][argType].command
      else
        commandContext.command = @runOptions.cmd

      buildArgsArray = grammarMap[lang][argType].args
      commandContext.args = buildArgsArray arg

    catch error
      err = $$ ->
        @p class: 'block', "#{argType} runner not available for #{lang}."
        @p class: 'block', =>
          @text 'If it should exist, add an '
          @a href: "https://github.com/rgbkrk/atom-script/issues/\
            new?title=Add%20support%20for%20#{lang}", 'issue on GitHub'
          @text ', or send your own pull request.'

      @handleError err
      return false

    # Update header
    @headerView.title.text "#{lang} - #{filename}"

    # Return setup information
    return commandContext

  handleError: (err) ->
    # Display error and kill process
    @headerView.title.text 'Error'
    @headerView.setStatus 'err'
    @output.append err
    @stop()

  run: (command, extraArgs) ->
    atom.emit 'achievement:unlock', msg: 'Homestar Runner'

    # Default to where the user opened atom
    options =
      cwd: @getCwd()
      env: process.env
    args = (@runOptions.cmdArgs.concat extraArgs).concat @runOptions.scriptArgs

    stdout = (output) => @display 'stdout', output
    stderr = (output) => @display 'stderr', output
    exit = (returnCode) =>
      if returnCode is 0
        @headerView.setStatus 'stop'
      else
        @headerView.setStatus 'err'
      console.log "Exited with #{returnCode}"

    # Run process
    @bufferedProcess = new BufferedProcess({
      command, args, options, stdout, stderr, exit
    })

    @bufferedProcess.process.on 'error', (nodeError) =>
      @output.append $$ ->
        @h1 'Unable to run'
        @pre _.escape command
        @h2 'Is it on your path?'
        @pre "PATH: #{_.escape process.env.PATH}"

  getCwd: ->
    if not @runOptions.workingDirectory? or @runOptions.workingDirectory is ''
      atom.project.getPath()
    else
      @runOptions.workingDirectory

  stop: ->
    # Kill existing process if available
    if @bufferedProcess? and @bufferedProcess.process?
      @display 'stdout', '^C'
      @headerView.setStatus 'kill'
      @bufferedProcess.kill()

  display: (css, line) ->
    line = _.escape(line)
    line = @ansiFilter.toHtml(line)

    @output.append $$ ->
      @pre class: "line #{css}", =>
        @raw line
