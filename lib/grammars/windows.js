import GrammarUtils from "../grammar-utils"

//if GrammarUtils.OperatingSystem.isWindows()

export let AutoHotKey = {
  "Selection Based": {
    command: "AutoHotKey",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
    },
  },

  "File Based": {
    command: "AutoHotKey",
    args({ filepath }) {
      return [filepath]
    },
  },
}

export let Batch = {
  "File Based": {
    command: "cmd.exe",
    args({ filepath }) {
      return ["/q", "/c", filepath]
    },
  },
}

exports["Batch File"] = exports.Batch

export let PowerShell = {
  "Selection Based": {
    command: "powershell",
    args(context) {
      return [context.getCode()]
    },
  },

  "File Based": {
    command: "powershell",
    args({ filepath }) {
      return [filepath.replace(/\ /g, "` ")]
    },
  },
}

export let VBScript = {
  "Selection Based": {
    command: "cscript",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".vbs")
      return ["//NOLOGO", tmpFile]
    },
  },

  "File Based": {
    command: "cscript",
    args({ filepath }) {
      return ["//NOLOGO", filepath]
    },
  },
}
