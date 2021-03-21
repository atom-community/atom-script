/*
 * decaffeinate suggestions:
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let GrammarUtils
import path from "path"
const { command } = (GrammarUtils = require("../grammar-utils"))

const bin = path.join(__dirname, "../..", "node_modules", ".bin")
const coffee = path.join(bin, "coffee")
const babel = path.join(bin, "babel")
const babelConfig = path.join(__dirname, "babel.config.js")

const args = function ({ filepath }) {
  const cmd = `'${coffee}' -p '${filepath}'|'${babel}' --filename '${bin} --config-file ${babelConfig}'| node`
  return GrammarUtils.formatArgs(cmd)
}

export let CoffeeScript = {
  "Selection Based": {
    command,
    args(context) {
      const { scopeName } = __guard__(atom.workspace.getActiveTextEditor(), (x) => x.getGrammar())
      const lit = (scopeName != null ? scopeName.includes("lit") : undefined) ? "lit" : ""
      const code = context.getCode()
      const filepath = GrammarUtils.createTempFileWithCode(code, `.${lit}coffee`)
      return args({ filepath })
    },
  },
  "File Based": { command, args },
}

exports["CoffeeScript (Literate)"] = exports.CoffeeScript

export let IcedCoffeeScript = {
  "Selection Based": {
    command: "iced",
    args(context) {
      return ["-e", context.getCode()]
    },
  },

  "File Based": {
    command: "iced",
    args({ filepath }) {
      return [filepath]
    },
  },
}

function __guard__(value, transform) {
  return typeof value !== "undefined" && value !== null ? transform(value) : undefined
}
