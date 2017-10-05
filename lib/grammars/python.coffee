exports.Python =
  'Selection Based':
    command: 'python'
    args: (context) -> ['-u', '-c', context.getCode()]

  'File Based':
    command: 'python'
    args: ({filepath}) -> ['-u', filepath]

exports.MagicPython = exports.Python

exports.Sage =
  'Selection Based':
    command: 'sage'
    args: (context) -> ['-c', context.getCode()]

  'File Based':
    command: 'sage'
    args: ({filepath}) -> [filepath]
