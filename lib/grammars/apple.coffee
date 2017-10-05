#{OperatingSystem} = require '../grammar-utils'

module.exports = #if OperatingSystem.isDarwin()

  AppleScript:
    'Selection Based':
      command: 'osascript'
      args: (context) -> ['-e', context.getCode()]

    'File Based':
      command: 'osascript'
      args: ({filepath}) -> [filepath]

  Swift:
    'File Based':
      command: 'swift'
      args: ({filepath}) -> [filepath]
