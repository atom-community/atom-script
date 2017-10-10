module.exports =

  RSpec:
    'Selection Based':
      command: 'ruby'
      args: (context) -> ['-e', context.getCode()]

    'File Based':
      command: 'rspec'
      args: ({filepath}) -> ['--tty', '--color', filepath]

    'Line Number Based':
      command: 'rspec'
      args: (context) -> ['--tty', '--color', context.fileColonLine()]

  Ruby:
    'Selection Based':
      command: 'ruby'
      args: (context) -> ['-e', context.getCode()]

    'File Based':
      command: 'ruby'
      args: ({filepath}) -> [filepath]

  'Ruby on Rails':

    'Selection Based':
      command: 'rails'
      args: (context) -> ['runner', context.getCode()]

    'File Based':
      command: 'rails'
      args: ({filepath}) -> ['runner', filepath]
