CodeContextBuilder = require './code-context-builder'
GrammarUtils = require './grammar-utils'
Runner = require './runner'
Runtime = require './runtime'
ScriptOptions = require './script-options'
ScriptOptionsView = require './script-options-view'
ScriptProfileRunView = require './script-profile-run-view'
ScriptView = require './script-view'
ViewRuntimeObserver = require './view-runtime-observer'

{CompositeDisposable} = require 'atom'

module.exports =
  config:
    enableExecTime:
      title: 'Output the time it took to execute the script'
      type: 'boolean'
      default: true
    escapeConsoleOutput:
      title: 'HTML escape console output'
      type: 'boolean'
      default: true
    ignoreSelection:
      title: 'Ignore selection (file-based runs only)'
      type: 'boolean'
      default: false
    scrollWithOutput:
      title: 'Scroll with output'
      type: 'boolean'
      default: true
    stopOnRerun:
      title: 'Stop running process on rerun'
      type: 'boolean'
      default: false
    cwdBehavior:
      title: 'Default CWD Behavior'
      description: 'If no Run Options are set, this setting decides how to determine the CWD'
      type: 'string'
      default: 'First project directory'
      enum: [
        'First project directory'
        'Project directory of the script'
        'Directory of the script'
      ]
      # For some reason, the text of these options does not show in package settings view
      # default: 'firstProj'
      # enum: [
      #   {value: 'firstProj', description: 'First project directory (if there is one)'}
      #   {value: 'scriptProj', description: 'Project directory of the script (if there is one)'}
      #   {value: 'scriptDir', description: 'Directory of the script'}
      # ]
  scriptView: null
  scriptOptionsView: null
  scriptProfileRunView: null
  scriptOptions: null
  scriptProfiles: []

  activate: (state) ->
    @scriptView = new ScriptView state.scriptViewState
    @scriptOptions = new ScriptOptions()
    @scriptOptionsView = new ScriptOptionsView @scriptOptions

    # profiles loading
    @scriptProfiles = []
    if state.profiles
      for profile in state.profiles
        so = ScriptOptions.createFromOptions profile.name, profile
        @scriptProfiles.push so

    @scriptProfileRunView = new ScriptProfileRunView @scriptProfiles

    codeContextBuilder = new CodeContextBuilder
    runner = new Runner(@scriptOptions)

    observer = new ViewRuntimeObserver(@scriptView)

    @runtime = new Runtime(runner, codeContextBuilder, [observer])

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @closeScriptViewAndStopRunner()
      'core:close': => @closeScriptViewAndStopRunner()
      'script:close-view': => @closeScriptViewAndStopRunner()
      'script:copy-run-results': => @scriptView.copyResults()
      'script:kill-process': => @runtime.stop()
      'script:run-by-line-number': => @runtime.execute('Line Number Based')
      'script:run': => @runtime.execute('Selection Based')

    # profile created
    @scriptOptionsView.onProfileSave (profileData) =>
      # create and fill out profile
      profile = ScriptOptions.createFromOptions profileData.name, profileData.options

      codeContext = @runtime.codeContextBuilder.buildCodeContext(atom.workspace.getActiveTextEditor(),
        "Selection Based")
      profile.lang = codeContext.lang

      # formatting description
      opts = profile.toObject()
      desc = "Language: #{codeContext.lang}"
      desc += ", Command: #{opts.cmd}" if opts.cmd
      desc += " #{opts.cmdArgs.join ' '}" if opts.cmdArgs and opts.cmd

      profile.description = desc
      @scriptProfiles.push profile

      @scriptOptionsView.hide()
      @scriptProfileRunView.show()
      @scriptProfileRunView.setProfiles @scriptProfiles

    # profile deleted
    @scriptProfileRunView.onProfileDelete (profile) =>
      index = @scriptProfiles.indexOf profile
      return unless index != -1

      @scriptProfiles.splice index, 1 if index != -1
      @scriptProfileRunView.setProfiles @scriptProfiles

    # profile renamed
    @scriptProfileRunView.onProfileChange (data) =>
      index = @scriptProfiles.indexOf data.profile
      return unless index != -1 and @scriptProfiles[index][data.key]?

      @scriptProfiles[index][data.key] = data.value
      @scriptProfileRunView.show()
      @scriptProfileRunView.setProfiles @scriptProfiles

    # profile renamed
    @scriptProfileRunView.onProfileRun (profile) =>
      return unless profile
      @runtime.execute 'Selection Based', null, profile

  deactivate: ->
    @runtime.destroy()
    @scriptView.removePanel()
    @scriptOptionsView.close()
    @scriptProfileRunView.close()
    @subscriptions.dispose()
    GrammarUtils.deleteTempFiles()

  closeScriptViewAndStopRunner: ->
    @runtime.stop()
    @scriptView.removePanel()

  # Public
  #
  # Service method that provides the default runtime that's configurable through Atom editor
  # Use this service if you want to directly show the script's output in the Atom editor
  #
  # **Do not destroy this {Runtime} instance!** By doing so you'll break this plugin!
  #
  # Also note that the Script package isn't activated until you actually try to use it.
  # That's why this service won't be automatically consumed. To be sure you consume it
  # you may need to manually activate the package:
  #
  #    atom.packages.loadPackage('script').activateNow() # this code doesn't include error handling!
  #
  # see https://github.com/s1mplex/Atom-Script-Runtime-Consumer-Sample for a full example
  provideDefaultRuntime: ->
    @runtime

  # Public
  #
  # Service method that provides a blank runtime. You are free to configure any aspect of it:
  # * Add observer (`runtime.addObserver(observer)`) - see {ViewRuntimeObserver} for an example
  # * configure script options (`runtime.scriptOptions`)
  #
  # In contrast to `provideDefaultRuntime` you should dispose this {Runtime} when
  # you no longer need it.
  #
  # Also note that the Script package isn't activated until you actually try to use it.
  # That's why this service won't be automatically consumed. To be sure you consume it
  # you may need to manually activate the package:
  #
  #    atom.packages.loadPackage('script').activateNow() # this code doesn't include error handling!
  #
  # see https://github.com/s1mplex/Atom-Script-Runtime-Consumer-Sample for a full example
  provideBlankRuntime: ->
    runner = new Runner(new ScriptOptions)
    codeContextBuilder = new CodeContextBuilder

    new Runtime(runner, codeContextBuilder, [])

  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    serializedProfiles = []
    serializedProfiles.push profile.toObject() for profile in @scriptProfiles

    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
    profiles: serializedProfiles
