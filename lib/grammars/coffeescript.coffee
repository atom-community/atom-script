module.exports =

  CoffeeScript:
    'Selection Based':
      command: 'coffee'
      args: (context) -> ['--transpile', '-e', context.getCode()]

    'File Based':
      command: 'coffee'
      args: ({filepath}) -> ['-t', filepath]

  'CoffeeScript (Literate)':

    'Selection Based':
      command: 'coffee'
      args: (context) -> ['-t', '-e', context.getCode()]

    'File Based':
      command: 'coffee'
      args: ({filepath}) -> ['-t', filepath]

  IcedCoffeeScript:
    'Selection Based':
      command: 'iced'
      args: (context) -> ['-e', context.getCode()]

    'File Based':
      command: 'iced'
      args: ({filepath}) -> [filepath]
