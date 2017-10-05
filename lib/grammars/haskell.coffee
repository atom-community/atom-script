exports.Haskell =
  'Selection Based':
    command: 'ghc'
    args: (context) -> ['-e', context.getCode()]

  'File Based':
    command: 'runhaskell'
    args: ({filepath}) -> [filepath]

exports['Literate Haskell'] =
  'File Based': exports.Haskell['File Based']
