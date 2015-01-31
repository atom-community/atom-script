{View} = require 'atom'

module.exports =
class ScriptOptionsView extends View

  @content: ->
    @div =>
      @div class: 'overlay from-top panel', outlet: 'scriptOptionsView', =>
        @div class: 'panel-heading', 'Configure Run Options'
        @div class: 'panel-body padded', =>
          @div class: 'block', =>
            @label 'Current Working Directory:'
            @input
              type: 'text'
              class: 'editor mini native-key-bindings'
              outlet: 'inputCwd'
          @div class: 'block', =>
            @label 'Command'
            @input
              type: 'text'
              class: 'editor mini native-key-bindings'
              outlet: 'inputCommand'
          @div class: 'block', =>
            @label 'Command Arguments:'
            @input
              type: 'text'
              class: 'editor mini native-key-bindings'
              outlet: 'inputCommandArgs'
          @div class: 'block', =>
            @label 'Program Arguments:'
            @input
              type: 'text'
              class: 'editor mini native-key-bindings'
              outlet: 'inputScriptArgs'
          @div class: 'block', =>
            @label 'Environment Variables:'
            @input
              type: 'text'
              class: 'editor mini native-key-bindings'
              outlet: 'inputEnv'
          @div class: 'block', =>
            css = 'btn inline-block-tight'
            @button class: "btn #{css}", click: 'close', 'Close'
            @button class: "btn #{css}", click: 'run', 'Run'

  initialize: (@runOptions) ->
    atom.commands.add 'atom-workspace', 'script:run-options', => @toggleScriptOptions()
    atom.commands.add 'atom-workspace', 'script:close-options', =>
      @toggleScriptOptions 'hide'
    atom.commands.add 'atom-workspace', 'script:save-options', => @saveOptions()
    atom.workspaceView.prependToTop this
    @toggleScriptOptions 'hide'

  toggleScriptOptions: (command) ->
    switch command
      when 'show' then @scriptOptionsView.show()
      when 'hide' then @scriptOptionsView.hide()
      else @scriptOptionsView.toggle()

  saveOptions: ->
    splitArgs = (element) ->
      item for item in element.val().split ' ' when item isnt ''

    @runOptions.workingDirectory = @inputCwd.val()
    @runOptions.cmd = @inputCommand.val()
    @runOptions.cmdArgs = splitArgs @inputCommandArgs
    @runOptions.env = @inputEnv.val()
    @runOptions.scriptArgs = splitArgs @inputScriptArgs

  close: ->
    atom.workspaceView.trigger 'script:close-options'

  run: ->
    atom.workspaceView.trigger 'script:save-options'
    atom.workspaceView.trigger 'script:close-options'
    atom.workspaceView.trigger 'script:run'
