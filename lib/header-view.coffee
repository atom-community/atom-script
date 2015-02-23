{View} = require 'atom-space-pen-views'

module.exports =
class HeaderView extends View

  @content: ->
    @div class: 'panel-heading padded heading header-view', =>
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status', outlet: 'status'
      @span
        class: 'heading-close icon-remove-close pull-right'
        outlet: 'closeButton'
        click: 'close'

  close: ->
    atom.workspaceView.trigger 'script:close-view'

  setStatus: (status) ->
    @status.removeClass 'icon-alert icon-check icon-hourglass icon-stop'
    switch status
      when 'start' then @status.addClass 'icon-hourglass'
      when 'stop' then @status.addClass 'icon-check'
      when 'kill' then @status.addClass 'icon-stop'
      when 'err' then @status.addClass 'icon-alert'
