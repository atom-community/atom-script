{View} = require 'atom'

module.exports =
class CustomOptionView extends View

  @content: ->
    @div class: "customOptionView", =>
      @div class: "overlay from-top", =>
        @div class: 'panel', =>
          @div class: 'panel-heading', 'Configure Run Options'
          @div class: 'panel-body padded', =>
            @div class: 'block', =>
              @label 'Current Working Directory:'
              @input type: 'text', class: 'editor mini editor-colors', outlet: 'inputCwd'
            @div class: 'block', =>
              @label 'Command Arguments:'
              @input type: 'text', class: 'editor mini editor-colors', outlet: 'inputCommandArgs'
            @div class: 'block', =>
              @label 'Script Arguments:'
              @input type: 'text', class: 'editor mini editor-colors', outlet: 'inputScriptArgs'
  close: ->
    atom.workspaceView.trigger "script:close-view"
