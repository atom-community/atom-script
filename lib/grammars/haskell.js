"use babel"

export const Haskell = {
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

exports["Literate Haskell"] = { "File Based": exports.Haskell["File Based"] }
