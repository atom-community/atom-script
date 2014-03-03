{ScrollView, BufferedProcess} = require 'atom'

# Runs a portion of a script through an interpreter and displays it line by line

module.exports =
class ScriptView extends ScrollView

  @content: ->
    @div class: 'script', tabindex: -1, =>
      @div class: 'output', outlet: 'output'

  constructor: (interpreter, make_args) ->
    super
    @interpreter = interpreter
    @make_args = make_args

  getTitle: ->
    if @interpreter?
      @interpreter
    else
      ":("

  addLine: (line, out_type) ->
    #console.log(line)
    @output.append("<pre class='line #{out_type}'>#{line}</pre>")

  runit: (err, code) ->

    if err?
      @addLine(err, "error")
      return

    command = @interpreter

    args = @make_args(code)

    # Default to where the user opened atom
    options =
      cwd: atom.project.getPath()
      env: process.env

    console.log("Running " + command + " " + args.join(" "))

    stdout = (output) => @addLine(output, "stdout")
    stderr = (output) => @addLine(output, "stderr")
    exit = (return_code) -> console.log("Exited with #{return_code}")

    @bufferedProcess = new BufferedProcess({command, args, options, stdout, stderr, exit})

  stopit: ->
    @bufferedProcess.kill() if @bufferedProcess.process?
