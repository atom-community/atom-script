{CompositeDisposable, Emitter} = require 'atom'
{View} = require 'atom-space-pen-views'
ScriptInputView = require './script-input-view'

module.exports =
class ScriptOptionsView extends View

  @content: ->
    @div class: 'options-view', =>
      @div class: 'panel-heading', 'Configure Run Options'
      @table =>
        @tr =>
          @td class: 'first', => @label 'Current Working Directory:'
          @td class: 'second', =>
            @tag 'atom-text-editor', mini: '', class: 'editor mini', outlet: 'inputCwd'
        @tr =>
          @td => @label 'Command'
          @td =>
            @tag 'atom-text-editor', mini: '', class: 'editor mini', outlet: 'inputCommand'
        @tr =>
          @td => @label 'Command Arguments:'
          @td =>
            @tag 'atom-text-editor', mini: '', class: 'editor mini', outlet: 'inputCommandArgs'
        @tr =>
          @td => @label 'Program Arguments:'
          @td =>
            @tag 'atom-text-editor', mini: '', class: 'editor mini', outlet: 'inputScriptArgs'
        @tr =>
          @td => @label 'Environment Variables:'
          @td =>
            @tag 'atom-text-editor', mini: '', class: 'editor mini', outlet: 'inputEnv'
      @div class: 'block buttons', =>
        css = 'btn inline-block-tight'
        @button class: "btn #{css} cancel", outlet: 'buttonCancel', click: 'close', =>
          @span class: 'icon icon-x', 'Cancel'
        @span class: 'right-buttons', =>
          @button class: "btn #{css} save-profile", outlet: 'buttonSaveProfile', click: 'saveProfile', =>
            @span class: 'icon icon-file-text', 'Save as profile'
          @button class: "btn #{css} run", outlet: 'buttonRun', click: 'run', =>
            @span class: 'icon icon-playback-play', 'Run'

  initialize: (@runOptions) ->
    @emitter = new Emitter

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @hide()
      'core:close': => @hide()
      'script:close-options': => @hide()
      'script:run-options': => if @panel.isVisible() then @hide() else @show()
      'script:save-options': => @saveOptions()

    # handling focus traversal and run on enter
    @find('atom-text-editor').on 'keydown', (e) =>
      return true unless e.keyCode == 9 or e.keyCode == 13

      switch e.keyCode
        when 9
          e.preventDefault()
          e.stopPropagation()
          row = @find(e.target).parents('tr:first').nextAll('tr:first')
          if row.length then row.find('atom-text-editor').focus() else @buttonCancel.focus()

        when 13 then @run()

    @panel = atom.workspace.addModalPanel item: this
    @panel.hide()

  splitArgs: (element) ->
    args = element.get(0).getModel().getText().trim()

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
    (args = args.replace(new RegExp(part, 'g'), match)) for match, part of replaces
    split = (item for item in args.split ' ' when item isnt '')

    replacer = (argument) ->
      (argument = argument.replace(match, replacement)) for match, replacement of replaces
      argument

    # restore strings, strip quotes
    (replacer(argument).replace(/"|'/g, '') for argument in split)

  getOptions: ->
    workingDirectory: @inputCwd.get(0).getModel().getText()
    cmd: @inputCommand.get(0).getModel().getText()
    cmdArgs: @splitArgs @inputCommandArgs
    env: @inputEnv.get(0).getModel().getText()
    scriptArgs: @splitArgs @inputScriptArgs

  saveOptions: ->
    @runOptions[key] = value for key, value of @getOptions()

  onProfileSave: (callback) -> @emitter.on 'on-profile-save', callback

  # Saves specified options as new profile
  saveProfile: ->
    @hide()

    options = @getOptions()

    inputView = new ScriptInputView caption: 'Enter profile name:'
    inputView.onCancel =>
      @show()
    inputView.onConfirm (profileName) =>
      return unless profileName
      editor.getModel().setText('') for editor in @find('atom-text-editor')

      # clean up the options
      @saveOptions()

      # add to global profiles list
      @emitter.emit 'on-profile-save', name: profileName, options: options

    inputView.show()

  close: ->
    @hide()

  destroy: ->
    @subscriptions?.dispose()

  show: ->
    @panel.show()
    @inputCwd.focus()

  hide: ->
    @panel.hide()
    atom.workspace.getActivePane().activate()

  run: ->
    @saveOptions()
    @hide()
    atom.commands.dispatch @workspaceView(), 'script:run'

  workspaceView: ->
    atom.views.getView(atom.workspace)
