{CompositeDisposable} = require 'atom'
{View} = require 'atom-space-pen-views'

module.exports =
class ScriptOptionsView extends View

  @content: ->
    @div =>
      @div class: 'overlay from-top panel options-view', outlet: 'scriptOptionsView', =>
        @div class: 'panel-heading', 'Configure Run Options'
        @table =>
          @tr =>
            @td => @label 'Current Working Directory:'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'inputCwd'
          @tr =>
            @td => @label 'Command'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'inputCommand'
          @tr =>
            @td => @label 'Command Arguments:'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'inputCommandArgs'
          @tr =>
            @td => @label 'Program Arguments:'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'inputScriptArgs'
          @tr =>
            @td => @label 'Environment Variables:'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'inputEnv'
        @div class: 'block buttons', =>
          css = 'btn inline-block-tight'
          @button class: "btn #{css} cancel", click: 'close', =>
            @span class: 'icon icon-x', 'Cancel'
          @button class: "btn #{css} run", outlet: 'buttonRun', click: 'run', =>
            @span class: 'icon icon-playback-play', 'Run'

  initialize: (@runOptions) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @toggleScriptOptions('hide')
      'core:close': => @toggleScriptOptions('hide')
      'script:close-options': => @toggleScriptOptions('hide')
      'script:run-options': => @toggleScriptOptions()
      'script:save-options': => @saveOptions()
    atom.workspace.addTopPanel(item: this)
    @toggleScriptOptions 'hide'

  toggleScriptOptions: (command) ->
    switch command
      when 'show'
        @scriptOptionsView.show()
        @inputCwd.focus()
      when 'hide' then @scriptOptionsView.hide()
      else
        @scriptOptionsView.toggle()
        @inputCwd.focus() if @scriptOptionsView.is(':visible')

  saveOptions: ->
    splitArgs = (element) ->
      item for item in element.val().split ' ' when item isnt ''

    @runOptions.workingDirectory = @inputCwd.val()
    @runOptions.cmd = @inputCommand.val()
    @runOptions.cmdArgs = splitArgs @inputCommandArgs
    @runOptions.env = @inputEnv.val()
    @runOptions.scriptArgs = splitArgs @inputScriptArgs

  close: ->
    @toggleScriptOptions('hide')

  destroy: ->
    @subscriptions?.dispose()

  run: ->
    @saveOptions()
    @toggleScriptOptions('hide')
    atom.commands.dispatch @workspaceView(), 'script:run'

  traverseFocus: (e) ->
    return true if e.keyCode != 9

    row = @find(e.target).parents('tr:first').nextAll('tr:first')
    if row.length then row.find('input').focus() else @buttonRun.focus()

  workspaceView: ->
    atom.views.getView(atom.workspace)
