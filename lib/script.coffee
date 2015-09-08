CodeContextBuilder = require './code-context-builder'
GrammarUtils = require './grammar-utils'
Runner = require './runner'
Runtime = require './runtime'
ScriptOptions = require './script-options'
ScriptOptionsView = require './script-options-view'
ScriptView = require './script-view'
ViewFormatter = require './view-formatter'

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

    @codeContextBuilder = new CodeContextBuilder(@scriptView)
    runner = new Runner(@scriptOptions)

    formatter = new ViewFormatter(@scriptView)

    @runtime = new Runtime(runner, @codeContextBuilder, [formatter], @scriptView)

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
  provideDefaultRuntime: ->
    @runtime

  # Public
  #
  # Service method that provides a blank runtime. You are free to configure any aspect of it:
  # * Add formatter (`runtime.addFormatter(formatter)`)
  # * configure script options (`runtime.scriptOptions`)
  #
  # In contrast to `provideDefaultRuntime` you should dispose this {Runtime} when
  # you no longer need it.
  provideBlankRuntime: ->
    runner = new Runner(new ScriptOptions)

    new Runtime(runner, @codeContextBuilder, [], @scriptView)

  serialize: ->
    # TODO: True serialization needs to take the options view into account
    #       and handle deserialization
    scriptViewState: @scriptView.serialize()
    scriptOptionsViewState: @scriptOptionsView.serialize()
