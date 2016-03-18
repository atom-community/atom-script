{CompositeDisposable, Emitter} = require 'atom'
{$$, View, SelectListView} = require 'atom-space-pen-views'
ScriptInputView = require './script-input-view'

module.exports =
class ScriptProfileRunView extends SelectListView
  initialize: (@profiles) ->
    super

    @emitter = new Emitter

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @hide()
      'core:close': => @hide()
      'script:run-with-profile': => if @panel.isVisible() then @hide() else @show()

    @setItems @profiles
    @initializeView()

  initializeView: ->
    @addClass 'overlay from-top script-profile-run-view'
    # @panel.hide()

    @buttons = $$ ->
      @div class: 'block buttons', =>
        css = 'btn inline-block-tight'
        @button class: "btn cancel", =>
          @span class: 'icon icon-x', 'Cancel'
        @button class: "btn rename", =>
          @span class: 'icon icon-pencil', 'Rename'
        @button class: "btn delete", =>
          @span class: 'icon icon-trashcan', 'Delete'
        @button class: "btn run", =>
          @span class: 'icon icon-playback-play', 'Run'

    # event handlers
    @buttons.find('.btn.cancel').on 'click', => @hide()
    @buttons.find('.btn.rename').on 'click', => @rename()
    @buttons.find('.btn.delete').on 'click', => @delete()
    @buttons.find('.btn.run').on 'click', => @run()

    # fix focus traversal (from run button to filter editor)
    @buttons.find('.btn.run').on 'keydown', (e) =>
      if e.keyCode == 9
        e.stopPropagation()
        e.preventDefault()
        @focusFilterEditor()

    # hide panel on ecsape
    @.on 'keydown', (e) =>
      @hide() if e.keyCode == 27
      @run() if e.keyCode == 13

    # append buttons container
    @append @buttons

    selector = '.rename, .delete, .run'
    if @profiles.length then @buttons.find(selector).show() else @buttons.find(selector).hide()

    @panel = atom.workspace.addModalPanel item: this
    @panel.hide()

  onProfileDelete: (callback) -> @emitter.on 'on-profile-delete', callback
  onProfileChange: (callback) -> @emitter.on 'on-profile-change', callback
  onProfileRun: (callback) -> @emitter.on 'on-profile-run', callback

  rename: ->
    profile = @getSelectedItem()
    return unless profile

    inputView = new ScriptInputView caption: 'Enter new profile name:', default: profile.name
    inputView.onCancel => @show()
    inputView.onConfirm (newProfileName) =>
      return unless newProfileName
      @emitter.emit 'on-profile-change', profile: profile, key: 'name', value: newProfileName

    inputView.show()

  delete: ->
    profile = @getSelectedItem()
    return unless profile

    atom.confirm
      message: 'Delete profile'
      detailedMessage: "Are you sure you want to delete \"#{profile.name}\" profile?"
      buttons:
        No: => @focusFilterEditor()
        Yes: => @emitter.emit 'on-profile-delete', profile

  getFilterKey: ->
    'name'

  getEmptyMessage: ->
    'No profiles found'

  viewForItem: (item) ->
    $$ -> @li class: 'two-lines profile', =>
      @div class: 'primary-line name', =>
        @text item.name
      @div class: 'secondary-line description', =>
        @text item.description

  cancel: ->
  confirmed: (item) ->

  show: ->
    @panel.show()
    @focusFilterEditor()

  hide: ->
    @panel.hide()
    atom.workspace.getActivePane().activate()

  # Updates profiles
  setProfiles: (profiles) ->
    @profiles = profiles
    @setItems @profiles

    # toggle profile controls
    selector = '.rename, .delete, .run'
    if @profiles.length then @buttons.find(selector).show() else @buttons.find(selector).hide()

    @populateList()
    @focusFilterEditor()

  close: ->

  destroy: ->
    @subscriptions?.dispose()

  run: ->
    profile = @getSelectedItem()
    return unless profile

    @emitter.emit 'on-profile-run', profile
    @hide()


