"use babel"

import GrammarUtils from "../grammar-utils"

exports["Bash Automated Test System (Bats)"] = {
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

export const Bash = {
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

exports["Shell Script"] = exports.Bash

exports["Shell Script (Fish)"] = {
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

export const Tcl = {
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
