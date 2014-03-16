{View} = require 'atom'

module.exports =
class CustomOptionView extends View

  @content: ->
    @div class: "customOptionView", =>
      @div class: "overlay overlay-top", =>
        @div class: 'panel', =>
          @div class: 'panel-heading', 'Configure Run Options'
          @div class: 'panel-body padded', =>
            @div class: 'block', =>
              @label 'Current Working Directory:'
            @div class: 'block', =>
              @input type: 'text'
            @div lass: 'block', =>
              @label 'Command Arguments:'
            @div class: 'block', =>
              @input type: 'text'
            @div lass: 'block', =>
              @label 'Script Arguments:'
            @div class: 'block', =>
              @input type: 'text'
  close: ->
    atom.workspaceView.trigger "script:close-view"
