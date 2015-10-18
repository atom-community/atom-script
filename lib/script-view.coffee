HeaderView = require './header-view'
ScriptOptionsView = require './script-options-view'

{View, $$} = require 'atom-space-pen-views'

AnsiFilter = require 'ansi-to-html'
stripAnsi = require 'strip-ansi'
linkPaths = require './link-paths'
_ = require 'underscore'

# Runs a portion of a script through an interpreter and displays it line by line
module.exports =
class ScriptView extends View
  @results: ""

  @content: ->
    @div =>
      @subview 'headerView', new HeaderView()

      # Display layout and outlets
      css = 'tool-panel panel panel-bottom padding script-view
        native-key-bindings'
      @div class: css, outlet: 'script', tabindex: -1, =>
        @div class: 'panel-body padded output', outlet: 'output'

  initialize: (serializeState) ->
    @ansiFilter = new AnsiFilter

    linkPaths.listen @

  serialize: ->

  setHeaderAndShowExecutionTime: (returnCode, executionTime) =>
    @display 'stdout', '[Finished in '+executionTime.toString()+'s]'
    if returnCode is 0
      @setHeaderStatus 'stop'
    else
      @setHeaderStatus 'err'

  resetView: (title = 'Loading...') ->
    # Display window and load message

    # First run, create view
    atom.workspace.addBottomPanel(item: this) unless @hasParent()

    # Close any existing process and start a new one
    @stop()

    @headerView.title.text title
    @headerView.setStatus 'start'

    # Get script view ready
    @output.empty()

    # Remove the old script results
    @results = ""

  close: ->
    @stop()
    if @hasParent()
      grandParent = @script.parent().parent()
      @detach()
      grandParent.remove()

  stop: ->
    @display 'stdout', '^C'
    @headerView.setStatus 'kill'

  createGitHubIssueLink: (argType, lang) ->
    title = "Add #{argType} support for #{lang}"
    body = """
           ##### Platform: `#{process.platform}`
           ---
           """
    encodedURI = encodeURI("https://github.com/rgbkrk/atom-script/issues/new?title=#{title}&body=#{body}")
    # NOTE: Replace "#" after regular encoding so we don't double escape it.
    encodedURI = encodedURI.replace(/#/g, '%23')

    err = $$ ->
      @p class: 'block', "#{argType} runner not available for #{lang}."
      @p class: 'block', =>
        @text 'If it should exist, add an '
        @a href: encodedURI, 'issue on GitHub'
        @text ', or send your own pull request.'
    @handleError(err)

  showUnableToRunError: (command) ->
    @output.append $$ ->
      @h1 'Unable to run'
      @pre _.escape command
      @h2 'Did you start Atom from the command line?'
      @pre '  atom .'
      @h2 'Is it in your PATH?'
      @pre "PATH: #{_.escape process.env.PATH}"

  showNoLanguageSpecified: ->
    err = $$ ->
      @p 'You must select a language in the lower right, or save the file
        with an appropriate extension.'
    @handleError(err)

  showLanguageNotSupported: (lang) ->
    err = $$ ->
      @p class: 'block', "Command not configured for #{lang}!"
      @p class: 'block', =>
        @text 'Add an '
        @a href: "https://github.com/rgbkrk/atom-script/issues/\
          new?title=Add%20support%20for%20#{lang}", 'issue on GitHub'
        @text ' or send your own Pull Request.'
    @handleError(err)

  handleError: (err) ->
    # Display error and kill process
    @headerView.title.text 'Error'
    @headerView.setStatus 'err'
    @output.append err
    @stop()

  setHeaderStatus: (status) ->
    @headerView.setStatus status

  setHeaderTitle: (title) ->
    @headerView.title.text title

  display: (css, line) ->
    @results += line

    if atom.config.get('script.escapeConsoleOutput')
      line = _.escape(line)

    line = @ansiFilter.toHtml(line)
    line = linkPaths(line)

    padding = parseInt(@output.css('padding-bottom'))
    scrolledToEnd =
      @script.scrollBottom() == (padding + @output.trueHeight())

    lessThanFull = @output.trueHeight() <= @script.trueHeight()

    @output.append $$ ->
      @pre class: "line #{css}", =>
        @raw line

    if atom.config.get('script.scrollWithOutput')
      if lessThanFull or scrolledToEnd
        # Scroll down in a polling loop 'cause
        # we don't know when the reflow will finish.
        # See: http://stackoverflow.com/q/5017923/407845
        do @checkScrollAgain 5

  scrollTimeout: null
  checkScrollAgain: (times) ->
    =>
      @script.scrollToBottom()

      clearTimeout @scrollTimeout
      if times > 1
        @scrollTimeout = setTimeout @checkScrollAgain(times - 1), 50

  copyResults: ->
    if @results
      atom.clipboard.write stripAnsi(@results)
