{View} = require 'atom'

module.exports =
class HeaderView extends View

  @content: ->
    @div class: 'panel-heading padded heading', =>
      @span outlet: 'title'
      @span class: 'script-close', outlet: 'closeButton'
