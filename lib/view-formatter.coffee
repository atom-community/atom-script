{CompositeDisposable} = require 'atom'

module.exports =
class ViewFormatter
  constructor: (@runner, @view, @subscriptions = new CompositeDisposable) ->
    @subscriptions.add @runner.onDidWriteToStderr (ev) =>
      @view.display 'stderr', ev.message
    @subscriptions.add @runner.onDidWriteToStdout (ev) =>
      @view.display 'stdout', ev.message
    @subscriptions.add @runner.onDidExit (ev) =>
      @view.setHeaderAndShowExecutionTime ev.returnCode, ev.executionTime
    @subscriptions.add @runner.onDidNotRun (ev) =>
      @view.showUnableToRunError ev.command


  destroy: ->
    @subscriptions?.dispose()
