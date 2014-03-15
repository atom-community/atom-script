{View} = require 'atom'

module.exports =
class RunCustomView extends View

  @content: ->
    @div =>
      @input type: 'text'

  close: ->
    atom.workspaceView.trigger "script:close-view"
