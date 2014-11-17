grammarMap = require './grammars'
{View, BufferedProcess, $$} = require 'atom'
CodeContext = require './code-context'
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

  configDefaults:
    escapeConsoleOutput: true

  initialize: (serializeState, @runOptions) ->
    # Bind commands
    atom.workspaceView.command 'script:run', => @defaultRun()
    atom.workspaceView.command 'script:run-by-line-number', => @lineRun()
    atom.workspaceView.command 'script:close-view', => @close()
    atom.workspaceView.command 'script:kill-process', => @stop()

    @ansiFilter = new AnsiFilter

  serialize: ->

  updateOptions: (event) -> @runOptions = event.runOptions

  getShebang: (editor) ->
    text = editor.getText()
    lines = text.split("\n")
    firstLine = lines[0]
    return unless firstLine.match(/^#!/)

    firstLine.replace(/^#!\s*/, '')

  initCodeContext: (editor) ->
    filename = editor.getTitle()
    filepath = editor.getPath()
    selection = editor.getSelection()

    # If the selection was empty "select" ALL the text
    # This allows us to run on new files
    if selection.isEmpty()
      textSource = editor
    else
      textSource = selection

    codeContext = new CodeContext(filename, filepath, textSource)
    codeContext.selection = selection
    codeContext.shebang = @getShebang(editor)

    # Get language
    lang = @getLang editor

    if @validateLang lang
      codeContext.lang = lang

    return codeContext

  lineRun: ->
    @resetView()
    codeContext = @buildCodeContext('Line Number Based')
    @start(codeContext) unless not codeContext?

  defaultRun: ->
    @resetView()
    codeContext = @buildCodeContext() # Until proven otherwise
    @start(codeContext) unless not codeContext?

  buildCodeContext: (argType='Selection Based') ->
    # Get current editor
    editor = atom.workspace.getActiveEditor()
    # No editor available, do nothing
    return unless editor?

    codeContext = @initCodeContext(editor)

    codeContext.argType = argType

    if argType == 'Line Number Based'
      editor.save()
    else if codeContext.selection.isEmpty() and codeContext.filepath?
      codeContext.argType = 'File Based'
      editor.save()

    # Selection and Line Number Based runs both benefit from knowing the current line
    # number
    unless argType == 'File Based'
      cursor = editor.getCursor()
      codeContext.lineNumber = cursor.getScreenRow() + 1

    return codeContext

  start: (codeContext) ->

    # If language was not determined, do nothing
    if not codeContext.lang?
      # In the future we could handle a runner without the language being part
      # of the grammar map, using the options runner
      return

    commandContext = @setupRuntime codeContext
    @run commandContext.command, commandContext.args, codeContext if commandContext

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

  validateLang: (lang) ->
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

    return true

  setupRuntime: (codeContext) ->

    # Store information about the run
    commandContext = {}

    try
      if not @runOptions.cmd? or @runOptions.cmd is ''
        # Precondition: lang? and lang of grammarMap
        commandContext.command = codeContext.shebangCommand() or grammarMap[codeContext.lang][codeContext.argType].command
      else
        commandContext.command = @runOptions.cmd

      buildArgsArray = grammarMap[codeContext.lang][codeContext.argType].args

    catch error
      urlSafeArgType = "#{codeContext.argType}".replace(' ', '')
      urlSafeLang = "#{codeContext.lang}".replace(' ', '')
      err = $$ ->
        @p class: 'block', "#{codeContext.argType} runner not available for #{codeContext.lang}."
        @p class: 'block', =>
          @text 'If it should exist, add an '
          @a href: "https://github.com/rgbkrk/atom-script/issues/\
            new?title=Add%20#{urlSafeArgType}%20support%20for%20#{urlSafeLang}", 'issue on GitHub'
          @text ', or send your own pull request.'

      @handleError err
      return false

    # Update header to show the lang and file name
    if codeContext.argType is 'Line Number Based'
      @headerView.title.text "#{codeContext.lang} - #{codeContext.fileColonLine(false)}"
    else
      @headerView.title.text "#{codeContext.lang} - #{codeContext.filename}"

    try
      commandContext.args = buildArgsArray codeContext
    catch errorSendByArgs
      @handleError errorSendByArgs
      return false

    # Return setup information
    return commandContext

  handleError: (err) ->
    # Display error and kill process
    @headerView.title.text 'Error'
    @headerView.setStatus 'err'
    @output.append err
    @stop()

  run: (command, extraArgs, codeContext) ->
    atom.emit 'achievement:unlock', msg: 'Homestar Runner'
    startTime = new Date()

    # Default to where the user opened atom
    options =
      cwd: @getCwd()
      env: @runOptions.mergedEnv(process.env)
    args = (@runOptions.cmdArgs.concat extraArgs).concat @runOptions.scriptArgs
    if not @runOptions.cmd? or @runOptions.cmd is ''
      args = codeContext.shebangCommandArgs().concat args

    stdout = (output) => @display 'stdout', output
    stderr = (output) => @display 'stderr', output
    exit = (returnCode) =>
      if (atom.config.get 'script.enableExecTime') is true
        executionTime = (new Date().getTime() - startTime.getTime()) / 1000
        @display 'stdout', '[Finished in '+executionTime.toString()+'s]'

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
    if atom.config.get('script.escapeConsoleOutput')
      line = _.escape(line)
      line = @ansiFilter.toHtml(line)

    @output.append $$ ->
      @pre class: "line #{css}", =>
        @raw line
