{View} = require 'atom'

module.exports =
class ScriptOptionsView extends View

  @content: ->
    @div =>
      @div class: 'overlay from-top panel', outlet: 'scriptOptionsView', =>
        @div class: 'panel-heading', 'Configure Run Options'
        @div class: 'panel-body padded native-key-bindings', =>
          @div class: 'block', =>
            @label 'Current Working Directory:'
            @input type: 'text', class: 'editor mini editor-colors ', outlet: 'inputCwd'
          @div class: 'block', =>
            @label 'Command Arguments:'
            @input type: 'text', class: 'editor mini editor-colors', outlet: 'inputCommandArgs'
          @div class: 'block', =>
            @label 'Program Arguments:'
            @input type: 'text', class: 'editor mini editor-colors', outlet: 'inputScriptArgs'
          @div class: 'block', =>
            @button class: 'btn btn-primary inline-block-tight', click: 'close', 'Close'
            @button class: 'btn btn-success inline-block-tight', click: 'run', 'Run'

  initialize: (run_options) ->
    atom.workspaceView.command "script:run-options", => @runOptions()
    atom.workspaceView.command "script:close-options", => @toggleScriptOptions('hide')
    atom.workspaceView.command "script:save-options", => @saveOptions()
    atom.workspaceView.prependToTop(this)
    @toggleScriptOptions('hide')
    @run_options = run_options

  runOptions: ->
    @toggleScriptOptions()


  toggleScriptOptions: (command) ->
    if command?
      if command == 'show'
        @scriptOptionsView.show()
      if command == 'hide'
        @scriptOptionsView.hide()
    else
      @scriptOptionsView.toggle()

  saveOptions: =>
    @run_options.cmd_cwd = @inputCwd.val()
    @run_options.cmd_args = (item for item in @inputCommandArgs.val().split(' ') when item != '')
    @run_options.script_args = (item for item in @inputScriptArgs.val().split(' ') when item != '')
    #atom.emit 'script:update-options', run_options: @run_options

  close: ->
    if @hasParent() then @detach()

  close: ->
    atom.workspaceView.trigger "script:close-options"
  run: ->
    atom.workspaceView.trigger "script:save-options"
    atom.workspaceView.trigger "script:close-options"
    atom.workspaceView.trigger "script:run"
