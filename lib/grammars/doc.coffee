{shell} = require 'electron'
GrammarUtils = require '../grammar-utils'

exports.DOT =
  'Selection Based':
    command: 'dot'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.dot')
      ['-Tpng', tmpFile, '-o', tmpFile + '.png']

  'File Based':
    command: 'dot'
    args: ({filepath}) -> ['-Tpng', filepath, '-o', filepath + '.png']

exports.gnuplot =
  'File Based':
    command: 'gnuplot'
    workingDirectory: atom.workspace.getActivePaneItem()?.buffer?.file?.getParent?().getPath?()
    args: ({filepath}) -> ['-p', filepath]

exports['Graphviz (DOT)'] =

  'Selection Based':
    command: 'dot'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.dot')
      return ['-Tpng', tmpFile, '-o', tmpFile + '.png']

  'File Based':
    command: 'dot'
    args: ({filepath}) -> ['-Tpng', filepath, '-o', filepath + '.png']

exports.HTML =
  'File Based':
    command: 'echo'
    args: ({filepath}) ->
      uri = 'file://' + filepath
      shell.openExternal(uri)
      return ['HTML file opened at:', uri]

exports.LaTeX =
  'File Based':
    command: 'latexmk'
    args: ({filepath}) -> ['-cd', '-quiet', '-pdf', '-pv', '-shell-escape', filepath]

exports['LaTeX Beamer'] = exports.LaTeX

exports['Pandoc Markdown'] =
  'File Based':
    command: 'panzer'
    args: ({filepath}) -> [filepath, "--output='#{filepath}.pdf'"]

exports.Sass =
  'File Based':
    command: 'sass'
    args: ({filepath}) -> [filepath]

exports.SCSS = exports.Sass
