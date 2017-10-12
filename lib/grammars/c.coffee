path = require 'path'
{OperatingSystem, command} = GrammarUtils = require '../grammar-utils'

os = OperatingSystem.platform()
windows = OperatingSystem.isWindows()

options = '-Wall -include stdio.h'

args = ({filepath}) ->
  args = switch os
    when 'darwin'
      "xcrun clang #{options} -fcolor-diagnostics '#{filepath}' -o /tmp/c.out && /tmp/c.out"
    when 'linux'
      "cc #{options} '#{filepath}' -o /tmp/c.out && /tmp/c.out"
  return ['-c', args]

exports.C =
  'File Based':
    command: 'bash'
    args: ({filepath}) ->
      args = switch os
        when 'darwin'
          "xcrun clang #{options} -fcolor-diagnostics '#{filepath}' -o /tmp/c.out && /tmp/c.out"
        when 'linux'
          "cc #{options} '#{filepath}' -o /tmp/c.out && /tmp/c.out"
      return ['-c', args]

  'Selection Based':
    command: 'bash'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.c')
      args = switch os
        when 'darwin'
          "xcrun clang #{options} -fcolor-diagnostics #{tmpFile} -o /tmp/c.out && /tmp/c.out"
        when 'linux'
          "cc #{options} #{tmpFile} -o /tmp/c.out && /tmp/c.out"
      return ['-c', args]

exports['C#'] =
  'Selection Based': {
    command
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.cs')
      exe = tmpFile.replace /\.cs$/, '.exe'
      if windows
        return ["/c csc /out:#{exe} #{tmpFile} && #{exe}"]
      else ['-c', "csc /out:#{exe} #{tmpFile} && mono #{exe}"]
  }
  'File Based': {
    command
    args: ({filepath, filename}) ->
      exe = filename.replace /\.cs$/, '.exe'
      if windows
        return ["/c csc #{filepath} && #{exe}"]
      else ['-c', "csc '#{filepath}' && mono #{exe}"]
  }
exports['C# Script File'] =

  'Selection Based':
    command: 'scriptcs'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.csx')
      return ['-script', tmpFile]
  'File Based':
    command: 'scriptcs'
    args: ({filepath}) -> ['-script', filepath]

exports['C++'] =
  'Selection Based':
    command: 'bash'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.cpp')
      args = switch os
        when 'darwin'
          "xcrun clang++ -std=c++14 #{options} -fcolor-diagnostics -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
        when 'linux'
          "g++ #{options} -std=c++14 -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
      return ['-c', args]

  'File Based': {
    command
    args: ({filepath}) ->
      args = switch os
        when 'darwin'
          "xcrun clang++ -std=c++14 #{options} -fcolor-diagnostics -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
        when 'linux'
          "g++ -std=c++14 #{options} -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
        when 'win32'
          if GrammarUtils.OperatingSystem.release().split('.').slice -1 >= '14399'
            filepath = path.posix.join.apply(path.posix, [].concat([filepath.split(path.win32.sep)[0].toLowerCase()], filepath.split(path.win32.sep).slice(1))).replace(':', '')
            "g++ -std=c++14 #{options} -include iostream /mnt/#{filepath} -o /tmp/cpp.out && /tmp/cpp.out"
      return GrammarUtils.formatArgs(args)
  }
exports['C++14'] = exports['C++']

if os is 'darwin'
  exports['Objective-C'] =
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "xcrun clang #{options} -fcolor-diagnostics -framework Cocoa '#{filepath}' -o /tmp/objc-c.out && /tmp/objc-c.out"]

  exports['Objective-C++'] =
      'File Based':
        command: 'bash'
        args: ({filepath}) -> ['-c', "xcrun clang++ -Wc++11-extensions #{options} -fcolor-diagnostics -include iostream -framework Cocoa '#{filepath}' -o /tmp/objc-cpp.out && /tmp/objc-cpp.out"]
