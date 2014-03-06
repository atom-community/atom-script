{View} = require 'atom'

module.exports =
class HeaderView extends View

  @content: ->
    @div class: 'panel-heading padded heading', =>
      @span outlet: 'title'
      @span class: 'pull-right icon-remove-close', outlet: 'closeButton', click: 'close'

  close: ->
    window.alert('close')
