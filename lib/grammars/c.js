"use babel"

import path from "path"
import GrammarUtils from "../grammar-utils"
const { OperatingSystem, command } = GrammarUtils

const os = OperatingSystem.platform()
const windows = OperatingSystem.isWindows()

const options = "-Wall -include stdio.h"

// TODO add windows support
function CArgs({ filepath }) {
  let cmdArgs = ""
  switch (os) {
    case "darwin":
      cmdArgs = `xcrun clang ${options} -fcolor-diagnostics '${filepath}' -o /tmp/c.out && /tmp/c.out`
      break
    case "linux":
      cmdArgs = `cc ${options} '${filepath}' -o /tmp/c.out && /tmp/c.out`
      break
    default: {
      atom.notifications.addError(`Not support on ${os}`)
    }
  }
  return ["-c", cmdArgs]
}

const C = {
  "File Based": {
    command: "bash",
    args(opts) {
      return CArgs(opts)
    },
  },

  "Selection Based": {
    command: "bash",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".c")
      return CArgs({ filepath: tmpFile })
    },
  },
}

const Cs = {
  "Selection Based": {
    command,
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".cs")
      const exe = tmpFile.replace(/\.cs$/, ".exe")
      if (windows) {
        return [`/c csc /out:${exe} ${tmpFile} && ${exe}`]
      } else {
        return ["-c", `csc /out:${exe} ${tmpFile} && mono ${exe}`]
      }
    },
  },
  "File Based": {
    command,
    args({ filepath, filename }) {
      const exe = filename.replace(/\.cs$/, ".exe")
      if (windows) {
        return [`/c csc ${filepath} && ${exe}`]
      } else {
        return ["-c", `csc '${filepath}' && mono ${exe}`]
      }
    },
  },
}
const CSScriptFile = {
  "Selection Based": {
    command: "scriptcs",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".csx")
      return ["-script", tmpFile]
    },
  },
  "File Based": {
    command: "scriptcs",
    args({ filepath }) {
      return ["-script", filepath]
    },
  },
}

const Cpp = {
  "Selection Based": {
    command: "bash",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".cpp")
      let cmdArgs = ""

      switch (os) {
        case "darwin":
          cmdArgs = `xcrun clang++ -std=c++14 ${options} -fcolor-diagnostics -include iostream ${tmpFile} -o /tmp/cpp.out && /tmp/cpp.out`
          break
        case "linux":
          cmdArgs = `g++ ${options} -std=c++14 -include iostream ${tmpFile} -o /tmp/cpp.out && /tmp/cpp.out`
          break
        default: {
          atom.notifications.addError(`Not support on ${os}`)
        }
      }
      return ["-c", cmdArgs]
    },
  },

  "File Based": {
    command,
    args({ filepath }) {
      let cmdArgs = ""
      switch (os) {
        case "darwin":
          cmdArgs = `xcrun clang++ -std=c++14 ${options} -fcolor-diagnostics -include iostream '${filepath}' -o /tmp/cpp.out && /tmp/cpp.out`
          break
        case "linux":
          cmdArgs = `g++ -std=c++14 ${options} -include iostream '${filepath}' -o /tmp/cpp.out && /tmp/cpp.out`
          break
        case "win32":
          if (
            GrammarUtils.OperatingSystem.release()
              .split(".")
              .slice(-1 >= "14399")
          ) {
            filepath = path.posix.join
              .apply(path.posix, [
                filepath.split(path.win32.sep)[0].toLowerCase(),
                ...filepath.split(path.win32.sep).slice(1),
              ])
              .replace(":", "")
            cmdArgs = `g++ -std=c++14 ${options} -include iostream /mnt/${filepath} -o /tmp/cpp.out && /tmp/cpp.out`
          }
          break
        default: {
          atom.notifications.addError(`Not support on ${os}`)
        }
      }
      return GrammarUtils.formatArgs(cmdArgs)
    },
  },
}
const Cpp14 = Cpp

const ObjectiveC = {
  "File Based": {
    command: "bash",
    args({ filepath }) {
      return [
        "-c",
        `xcrun clang ${options} -fcolor-diagnostics -framework Cocoa '${filepath}' -o /tmp/objc-c.out && /tmp/objc-c.out`,
      ]
    },
  },
}

const ObjectiveCpp = {
  "File Based": {
    command: "bash",
    args({ filepath }) {
      return [
        "-c",
        `xcrun clang++ -Wc++11-extensions ${options} -fcolor-diagnostics -include iostream -framework Cocoa '${filepath}' -o /tmp/objc-cpp.out && /tmp/objc-cpp.out`,
      ]
    },
  },
}

const CGrammars = {
  C,
  "C++": Cpp,
  "C++14": Cpp14,
  "C#": Cs,
  "C# Script File": CSScriptFile,
  "Objective-C": ObjectiveC,
  "Objective-C++": ObjectiveCpp,
}
export default CGrammars
