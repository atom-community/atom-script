"use babel"

import GrammarUtils from "../grammar-utils"

const Lua = {
  "Selection Based": {
    command: "lua",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
    },
  },

  "File Based": {
    command: "lua",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const WOW = Lua

const MoonScript = {
  "Selection Based": {
    command: "moon",
    args(context) {
      return ["-e", context.getCode()]
    },
  },

  "File Based": {
    command: "moon",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const LuaGrammars = {
  Lua,
  "Lua (WoW)": WOW,
  MoonScript,
}
export default LuaGrammars
