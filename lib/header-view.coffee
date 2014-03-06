{View} = require 'atom'

module.exports =
class HeaderView extends View

  @content: ->
    @div class: 'panel-heading padded heading headerView', =>
      @span class: 'heading-close icon-remove-close', outlet: 'closeButton', click: 'close'
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status', outlet: 'status'

  close: ->
    atom.workspaceView.trigger "script:close-view"

  setStatus: (status) ->
    @status.removeClass('icon-hourglass icon-stop icon-check')
    switch status
      when "start" then @status.addClass('icon-hourglass')
      when "err" then @status.addClass('icon-stop')
      when "stop" then @status.addClass('icon-check')
