path = require 'path'
{OperatingSystem} = GrammarUtils = require '../grammar-utils'

os = OperatingSystem.platform()
windows = OperatingSystem.isWindows()

exports.C =
  'File Based':
    command: 'bash'
    args: ({filepath}) ->
      args = switch os
        when 'darwin'
          "xcrun clang -fcolor-diagnostics -Wall -include stdio.h '#{filepath}' -o /tmp/c.out && /tmp/c.out"
        when 'linux'
          "cc -Wall -include stdio.h '#{filepath}' -o /tmp/c.out && /tmp/c.out"
      return ['-c', args]

  'Selection Based':
    command: 'bash'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.c')
      args = switch os
        when 'darwin'
          "xcrun clang -fcolor-diagnostics -Wall -include stdio.h #{tmpFile} -o /tmp/c.out && /tmp/c.out"
        when 'linux'
          "cc -Wall -include stdio.h #{tmpFile} -o /tmp/c.out && /tmp/c.out"
      return ['-c', args]

exports['C#'] =
  'Selection Based':
    command: if windows then 'cmd' else 'bash'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code, '.cs')
      progname = tmpFile.replace /\.cs$/, ''
      if windows
        return ["/c csc /out:#{progname}.exe #{tmpFile} && #{progname}.exe"]
      else ['-c', "csc /out:#{progname}.exe #{tmpFile} && mono #{progname}.exe"]

  'File Based':
    command: if windows then 'cmd' else 'bash'
    args: ({filepath, filename}) ->
      progname = filename.replace /\.cs$/, ''
      if windows
        return ["/c csc #{filepath} && #{progname}.exe"]
      else ['-c', "csc '#{filepath}' && mono #{progname}.exe"]

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
          "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
        when 'linux'
          "g++ -std=c++14 -Wall -include stdio.h -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
      return ['-c', args]

  'File Based':
    command: 'bash'
    args: ({filepath}) ->
      args = switch os
        when 'darwin'
          "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
        when 'linux'
          "g++ -std=c++14 -Wall -include stdio.h -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
        when 'win32'
          if GrammarUtils.OperatingSystem.release().split('.').slice -1 >= '14399'
            filepath = path.posix.join.apply(path.posix, [].concat([filepath.split(path.win32.sep)[0].toLowerCase()], filepath.split(path.win32.sep).slice(1))).replace(':', '')
            "g++ -std=c++14 -Wall -include stdio.h -include iostream '/mnt/#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
      return ['-c', args]

exports['C++14'] = exports['C++']

exports['Objective-C'] =
  if GrammarUtils.OperatingSystem.isDarwin()
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "xcrun clang -fcolor-diagnostics -Wall -include stdio.h -framework Cocoa '#{filepath}' -o /tmp/objc-c.out && /tmp/objc-c.out"]

exports['Objective-C++'] =
  if GrammarUtils.OperatingSystem.isDarwin()
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "xcrun clang++ -fcolor-diagnostics -Wc++11-extensions -Wall -include stdio.h -include iostream -framework Cocoa '#{filepath}' -o /tmp/objc-cpp.out && /tmp/objc-cpp.out"]
