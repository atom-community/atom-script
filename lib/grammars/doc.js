/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { shell } from "electron"
import GrammarUtils from "../grammar-utils"

export const DOT = {
  "Selection Based": {
    command: "dot",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".dot")
      return ["-Tpng", tmpFile, "-o", `${tmpFile  }.png`]
    },
  },

  "File Based": {
    command: "dot",
    args({ filepath }) {
      return ["-Tpng", filepath, "-o", `${filepath  }.png`]
    },
  },
}

export const gnuplot = {
  "File Based": {
    command: "gnuplot",
    workingDirectory: __guardMethod__(
      __guardMethod__(
        __guard__(
          __guard__(atom.workspace.getActivePaneItem(), (x1) => x1.buffer),
          (x) => x.file
        ),
        "getParent",
        (o1) => o1.getParent()
      ),
      "getPath",
      (o) => o.getPath()
    ),
    args({ filepath }) {
      return ["-p", filepath]
    },
  },
}

exports["Graphviz (DOT)"] = {
  "Selection Based": {
    command: "dot",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".dot")
      return ["-Tpng", tmpFile, "-o", `${tmpFile  }.png`]
    },
  },

  "File Based": {
    command: "dot",
    args({ filepath }) {
      return ["-Tpng", filepath, "-o", `${filepath  }.png`]
    },
  },
}

export const HTML = {
  "File Based": {
    command: "echo",
    args({ filepath }) {
      const uri = `file://${  filepath}`
      shell.openExternal(uri)
      return ["HTML file opened at:", uri]
    },
  },
}

export const LaTeX = {
  "File Based": {
    command: "latexmk",
    args({ filepath }) {
      return ["-cd", "-quiet", "-pdf", "-pv", "-shell-escape", filepath]
    },
  },
}

export const ConTeXt = {
  "File Based": {
    command: "context",
    args({ filepath }) {
      return ["--autopdf", "--nonstopmode", "--synctex", "--noconsole", filepath]
    },
  },
}

exports["LaTeX Beamer"] = exports.LaTeX

exports["Pandoc Markdown"] = {
  "File Based": {
    command: "panzer",
    args({ filepath }) {
      return [filepath, `--output='${filepath}.pdf'`]
    },
  },
}

export const Sass = {
  "File Based": {
    command: "sass",
    args({ filepath }) {
      return [filepath]
    },
  },
}

export const SCSS = exports.Sass

function __guardMethod__(obj, methodName, transform) {
  if (typeof obj !== "undefined" && obj !== null && typeof obj[methodName] === "function") {
    return transform(obj, methodName)
  } else {
    return undefined
  }
}
function __guard__(value, transform) {
  return typeof value !== "undefined" && value !== null ? transform(value) : undefined
}
