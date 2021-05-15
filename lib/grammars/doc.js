"use babel"

import { shell } from "electron"
import GrammarUtils from "../grammar-utils"

const DOT = {
  "Selection Based": {
    command: "dot",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".dot")
      return ["-Tpng", tmpFile, "-o", `${tmpFile}.png`]
    },
  },

  "File Based": {
    command: "dot",
    args({ filepath }) {
      return ["-Tpng", filepath, "-o", `${filepath}.png`]
    },
  },
}

const gnuplot = {
  "File Based": {
    command: "gnuplot",
    workingDirectory: GrammarUtils.workingDirectory(),
    args({ filepath }) {
      return ["-p", filepath]
    },
  },
}

const Graphviz = {
  "Selection Based": {
    command: "dot",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".dot")
      return ["-Tpng", tmpFile, "-o", `${tmpFile}.png`]
    },
  },

  "File Based": {
    command: "dot",
    args({ filepath }) {
      return ["-Tpng", filepath, "-o", `${filepath}.png`]
    },
  },
}

const HTML = {
  "File Based": {
    command: "echo",
    args({ filepath }) {
      const uri = `file://${filepath}`
      shell.openExternal(uri)
      return ["HTML file opened at:", uri]
    },
  },
}

const LaTeX = {
  "File Based": {
    command: "latexmk",
    args({ filepath }) {
      return ["-cd", "-quiet", "-pdf", "-pv", "-shell-escape", filepath]
    },
  },
}

const ConTeXt = {
  "File Based": {
    command: "context",
    args({ filepath }) {
      return ["--autopdf", "--nonstopmode", "--synctex", "--noconsole", filepath]
    },
  },
}

const LaTeXBeamer = LaTeX

const PandocMarkdown = {
  "File Based": {
    command: "panzer",
    args({ filepath }) {
      return [filepath, `--output='${filepath}.pdf'`]
    },
  },
}

const Sass = {
  "File Based": {
    command: "sass",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const SCSS = Sass

const Docs = {
  DOT,
  GNUPlot: gnuplot,
  gnuplot,
  "Graphviz (DOT)": Graphviz,
  HTML,
  LaTeX,
  ConTeXt,
  "LaTeX Beamer": LaTeXBeamer,
  "Pandoc Markdown": PandocMarkdown,
  Sass,
  SCSS,
}
export default Docs
