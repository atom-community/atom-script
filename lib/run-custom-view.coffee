{View} = require 'atom'

module.exports =
class RunCustomView extends View

  @content: ->
    @div =>
      @span "Test"

  close: ->
    atom.workspaceView.trigger "script:close-view"
