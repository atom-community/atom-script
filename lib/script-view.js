{View, $$} = require 'atom-space-pen-views'

HeaderView = require './header-view'
{MessagePanelView} = require 'atom-message-panel'
AnsiFilter = require 'ansi-to-html'
stripAnsi = require 'strip-ansi'
linkPaths = require './link-paths'
_ = require 'underscore'

# Runs a portion of a script through an interpreter and displays it line by line
module.exports =
class ScriptView extends MessagePanelView
  constructor: ->
    @ansiFilter = new AnsiFilter

    @headerView = new HeaderView

    super(title: @headerView, rawTitle: true, closeMethod: 'destroy')

    @addClass('script-view')
    @addShowInTabIcon()

    linkPaths.listen @body

  addShowInTabIcon: ->
    icon = $$ ->
      @div
        class: 'heading-show-in-tab inline-block icon-file-text'
        style: 'cursor: pointer;'
        outlet: 'btnShowInTab'
        title: 'Show output in new tab'

    icon.click @showInTab
    icon.insertBefore @btnAutoScroll

  showInTab: =>
    # concat output
    output = ''
    output += message.text() for message in @messages

    # represent command context
    context = ''
    if @commandContext
      context = "[Command: #{@commandContext.getRepresentation()}]\n"

    # open new tab and set content to output
    atom.workspace.open().then (editor) ->
      editor.setText stripAnsi(context + output)

  setHeaderAndShowExecutionTime: (returnCode, executionTime) =>
    if (executionTime?)
      @display 'stdout', '[Finished in '+executionTime.toString()+'s]'
    else
      @display 'stdout'

    if returnCode is 0
      @setHeaderStatus 'stop'
    else
      @setHeaderStatus 'err'

  resetView: (title = 'Loading...') ->
    # Display window and load message

    # First run, create view
    @attach() unless @hasParent()

    @setHeaderTitle title
    @setHeaderStatus 'start'

    # Get script view ready
    @clear()

  removePanel: ->
    @stop()
    @detach()
    # the 'close' method from MessagePanelView actually destroys the panel
    ScriptView.__super__.close.apply(this)

  # This is triggered when hitting the 'close' button on the panel
  # We are not actually closing the panel here since we want to trigger
  # 'script:close-view' which will eventually remove the panel via 'removePanel'
  close: ->
    workspaceView = atom.views.getView(atom.workspace)
    atom.commands.dispatch workspaceView, 'script:close-view'

  stop: ->
    @display 'stdout', '^C'
    @setHeaderStatus 'kill'

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
    @add $$ ->
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
    @setHeaderTitle 'Error'
    @setHeaderStatus 'err'
    @add(err)
    @stop()

  setHeaderStatus: (status) ->
    @headerView.setStatus status

  setHeaderTitle: (title) ->
    @headerView.title.text title

  display: (css, line) ->
    if atom.config.get('script.escapeConsoleOutput')
      line = _.escape(line)

    line = @ansiFilter.toHtml(line)
    line = linkPaths(line)

    {clientHeight, scrollTop, scrollHeight} = @body[0]
    # indicates that the panel is scrolled to the bottom, thus we know that
    # we are not interfering with the user's manual scrolling
    atEnd = scrollTop >= (scrollHeight - clientHeight)

    @add $$ ->
      @pre class: "line #{css}", =>
        @raw line

    if atom.config.get('script.scrollWithOutput') and atEnd
      # Scroll down in a polling loop 'cause
      # we don't know when the reflow will finish.
      # See: http://stackoverflow.com/q/5017923/407845
      do @checkScrollAgain 5

  scrollTimeout: null
  checkScrollAgain: (times) ->
    =>
      @body.scrollToBottom()

      clearTimeout @scrollTimeout
      if times > 1
        @scrollTimeout = setTimeout @checkScrollAgain(times - 1), 50

  copyResults: ->
    if @results
      atom.clipboard.write stripAnsi(@results)
