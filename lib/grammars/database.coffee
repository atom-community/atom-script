message = "SQL requires setting 'Script: Run Options' directly. See https://github.com/rgbkrk/atom-script/tree/master/examples/hello.sql for further information."

module.exports =

  'mongoDB (JavaScript)':

    'Selection Based':
      command: 'mongo'
      args: (context) -> ['--eval', context.getCode()]

    'File Based':
      command:  'mongo'
      args: ({filepath}) -> [filepath]

  SQL:
    'Selection Based':
      command: 'echo'
      args: -> [message]

    'File Based':
      command: 'echo'
      args: -> [message]

  'SQL (PostgreSQL)':

    'Selection Based':
      command: 'psql'
      args: (context) -> ['-c', context.getCode()]

    'File Based':
      command: 'psql'
      args: ({filepath}) -> ['-f', filepath]
