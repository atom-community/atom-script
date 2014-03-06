{View} = require 'atom'

module.exports =
class HeaderView extends View

  @content: ->
    @div class: 'panel-heading padded heading', =>
      @span class: 'heading-close icon-remove-close', outlet: 'closeButton', click: 'close'
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status icon-tmp', outlet: 'status'

  close: ->
    atom.workspaceView.trigger "script:close-view"

  setStatus: (status) ->
    # switch status
    #   when "start" then @status[0].className.replace('icon-tmp', 'icon-hourglass')
    #   when "kill" then @status.addClass(/\bicon-.*?\b/, 'icon-stop')
    #   when "stop" then @status.addClass(/\bicon-.*?\b/, 'icon-check')
