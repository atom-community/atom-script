{Emitter, CompositeDisposable} = require 'atom'
{$$, View} = require 'atom-space-pen-views'

module.exports =
class ScriptInputView extends View
  @content: ->
    @div class: 'script-input-view', =>
      @div class: 'caption', ''
      @tag 'atom-text-editor', mini: '', class: 'editor mini'

  initialize: (@options) ->
    @emitter = new Emitter

    @panel = atom.workspace.addModalPanel item: this
    @panel.hide()

    @editor = @find('atom-text-editor').get(0).getModel()

    # set default text
    if @options.default
      @editor.setText @options.default
      @editor.selectAll()

    # caption text
    if @options.caption
      @find('.caption').text @options.caption

    @find('atom-text-editor').on 'keydown', (e) =>
      if e.keyCode == 27
        e.stopPropagation()
        @emitter.emit 'on-cancel'
        @hide()

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:confirm': =>
        @emitter.emit 'on-confirm', @editor.getText().trim()
        @hide()

  onConfirm: (callback) -> @emitter.on 'on-confirm', callback
  onCancel: (callback) -> @emitter.on 'on-cancel', callback

  focus: ->
    @find('atom-text-editor').focus()

  show: ->
    @panel.show()
    @focus()

  hide: ->
    @panel.hide()
    @destroy()

  destroy: ->
    @subscriptions?.dispose()
    @panel.destroy()
