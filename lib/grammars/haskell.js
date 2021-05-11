"use babel"

const Haskell = {
  "Selection Based": {
    command: "ghc",
    args(context) {
      return ["-e", context.getCode()]
    },
  },

  "File Based": {
    command: "runhaskell",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const LiterateHaskell = { "File Based": Haskell["File Based"] }

const HaskellGrammars = {
  Haskell,
  "Literate Haskell": LiterateHaskell,
}
export default HaskellGrammars
