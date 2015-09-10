CodeContextBuilder = require './code-context-builder'
GrammarUtils = require './grammar-utils'
Runner = require './runner'
Runtime = require './runtime'
ScriptOptions = require './script-options'
ScriptOptionsView = require './script-options-view'
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
    scrollWithOutput:
      title: 'Scroll with output'
      type: 'boolean'
      default: true
  scriptView: null
  scriptOptionsView: null
  scriptOptions: null

  activate: (state) ->
    @scriptView = new ScriptView state.scriptViewState
    @scriptOptions = new ScriptOptions()
    @scriptOptionsView = new ScriptOptionsView @scriptOptions

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

  deactivate: ->
    @runtime.destroy()
    @scriptView.close()
    @scriptOptionsView.close()
    @subscriptions.dispose()
    GrammarUtils.deleteTempFiles()

  closeScriptViewAndStopRunner: ->
    @runtime.stop()
    @scriptView.close()

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
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
