{CompositeDisposable} = require 'atom'

module.exports =
class ViewRuntimeObserver
  constructor: (@view, @subscriptions = new CompositeDisposable) ->

  observe: (runtime) ->
    @subscriptions.add runtime.onDidExecuteStart =>
      @view.resetView()
    @subscriptions.add runtime.onDidWriteToStderr (ev) =>
      @view.display 'stderr', ev.message
    @subscriptions.add runtime.onDidWriteToStdout (ev) =>
      @view.display 'stdout', ev.message
    @subscriptions.add runtime.onDidExit (ev) =>
      @view.setHeaderAndShowExecutionTime ev.returnCode, ev.executionTime
    @subscriptions.add runtime.onDidNotRun (ev) =>
      @view.showUnableToRunError ev.command
    @subscriptions.add runtime.onDidContextCreate (ev) =>
      title = "#{ev.lang} - #{ev.filename + (":#{ev.lineNumber}" if ev.lineNumber?)}"
      @view.setHeaderTitle title
    @subscriptions.add runtime.onDidNotSpecifyLanguage =>
      @view.showNoLanguageSpecified()
    @subscriptions.add runtime.onDidNotSupportLanguage (ev) =>
      @view.showLanguageNotSupported ev.lang
    @subscriptions.add runtime.onDidNotSupportMode (ev) =>
      @view.createGitHubIssueLink ev.argType, ev.lang
    @subscriptions.add runtime.onDidNotBuildArgs (ev) =>
      @view.handleError ev.error

  destroy: ->
    @subscriptions?.dispose()
