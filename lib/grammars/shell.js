"use babel"

import GrammarUtils from "../grammar-utils"

const Bats = {
  "Selection Based": {
    command: "bats",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
    },
  },

  "File Based": {
    command: "bats",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const Bash = {
  "Selection Based": {
    command: process.env.SHELL,
    args(context) {
      return ["-c", context.getCode()]
    },
  },

  "File Based": {
    command: process.env.SHELL,
    args({ filepath }) {
      return [filepath]
    },
  },
}

const Shell = Bash

const Fish = {
  "Selection Based": {
    command: "fish",
    args(context) {
      return ["-c", context.getCode()]
    },
  },

  "File Based": {
    command: "fish",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const Tcl = {
  "Selection Based": {
    command: "tclsh",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
    },
  },

  "File Based": {
    command: "tclsh",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const ShellGrammars = {
  "Bash Automated Test System (Bats)": Bats,
  Bash,
  Tcl,
  "Shell Script": Shell,
  "Shell Script (Fish)": Fish,
}
export default ShellGrammars
