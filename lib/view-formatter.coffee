{CompositeDisposable} = require 'atom'

module.exports =
class ViewFormatter
  constructor: (@view, @subscriptions = new CompositeDisposable) ->

  listen: (runner) ->
    @subscriptions.add runner.onDidWriteToStderr (ev) =>
      @view.display 'stderr', ev.message
    @subscriptions.add runner.onDidWriteToStdout (ev) =>
      @view.display 'stdout', ev.message
    @subscriptions.add runner.onDidExit (ev) =>
      @view.setHeaderAndShowExecutionTime ev.returnCode, ev.executionTime
    @subscriptions.add runner.onDidNotRun (ev) =>
      @view.showUnableToRunError ev.command

  destroy: ->
    @subscriptions?.dispose()
