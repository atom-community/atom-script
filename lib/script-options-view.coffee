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

  splitArgs: (args) ->
    args = args.val().trim()

    if args.indexOf('"') == -1 and args.indexOf("'") == -1
      # no escaping, just split
      return (item for item in args.split ' ' when item isnt '')

    replaces = {}

    regexps = [/"[^"]*"/ig, /'[^']*'/ig]

    # find strings in arguments
    matches = (if matches? then matches else []).concat((args.match regex) or []) for regex in regexps

    # format replacement as bash comment to avoid replacing valid input
    (replaces['`#match' + (Object.keys(replaces).length + 1) + '`'] = match) for match in matches

    # replace strings
    args = (args.replace(new RegExp(part, 'g'), match) for match, part of replaces)
    split = (item for item in args.split ' ' when item isnt '')

    replacer = (argument) ->
      argument = (argument.replace(match, replacement) for match, replacement of replaces)
      argument

    # restore strings, strip quotes
    (replacer(argument).replace(/"|'/g, '') for argument in split)

  saveOptions: ->
    @runOptions.workingDirectory = @inputCwd.val()
    @runOptions.cmd = @inputCommand.val()
    @runOptions.cmdArgs = @splitArgs @inputCommandArgs
    @runOptions.env = @inputEnv.val()
    @runOptions.scriptArgs = @splitArgs @inputScriptArgs

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
