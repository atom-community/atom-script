GrammarUtils = require '../grammar-utils'

#if GrammarUtils.OperatingSystem.isWindows()

exports.AutoItv3 =
  'Selection Based':
    command: GrammarUtils.AutoItv3.getCommand() + "\\AutoIt3.exe"
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
  'File Based':
    command: GrammarUtils.AutoItv3.getCommand() + "\\AutoIt3.exe"
    args: ({filepath}) -> [GrammarUtils.AutoItv3.getCommand() + '\\SciTE\\AutoIt3Wrapper\\AutoIt3Wrapper.au3', '/run', '/prod', '/ErrorStdOut', '/in', filepath]

exports.AutoHotKey =
  'Selection Based':
    command: 'AutoHotKey'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]

  'File Based':
    command: 'AutoHotKey'
    args: ({filepath}) -> [filepath]

exports.Batch =
  'File Based':
    command: 'cmd.exe'
    args: ({filepath}) -> ['/q', '/c', filepath]

exports['Batch File'] = exports.Batch

exports.PowerShell =
  'Selection Based':
    command: 'powershell'
    args: (context) -> [context.getCode()]

  'File Based':
    command: 'powershell'
    args: ({filepath}) -> [filepath.replace /\ /g, '` ']

exports.VBScript =
  'Selection Based':
    command: 'cscript'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.vbs')
      return ['//NOLOGO', tmpFile]

  'File Based':
    command: 'cscript'
    args: ({filepath}) -> ['//NOLOGO', filepath]
