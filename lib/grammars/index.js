"use babel"

/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Maps Atom Grammar names to the command used by that language
// As well as any special setup for arguments.

import path from "path"
import GrammarUtils from "../grammar-utils"
const { OperatingSystem, command } = GrammarUtils

const os = OperatingSystem.platform()
const arch = OperatingSystem.architecture()
const windows = OperatingSystem.isWindows()

const OtherGrammars = {
  "1C (BSL)": {
    "File Based": {
      command: "oscript",
      args({ filepath }) {
        return ["-encoding=utf-8", filepath]
      },
    },
  },

  Ansible: {
    "File Based": {
      command: "ansible-playbook",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Clojure: {
    "Selection Based": {
      command: "lein",
      args(context) {
        return ["exec", "-e", context.getCode()]
      },
    },
    "File Based": {
      command: "lein",
      args({ filepath }) {
        return ["exec", filepath]
      },
    },
  },

  Crystal: {
    "Selection Based": {
      command: "crystal",
      args(context) {
        return ["eval", context.getCode()]
      },
    },
    "File Based": {
      command: "crystal",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  D: {
    "Selection Based": {
      command: "rdmd",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.D.createTempFileWithCode(code)
        return [tmpFile]
      },
    },
    "File Based": {
      command: "rdmd",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Elixir: {
    "Selection Based": {
      command: "elixir",
      args(context) {
        return ["-e", context.getCode()]
      },
    },
    "File Based": {
      command: "elixir",
      args({ filepath }) {
        return ["-r", filepath]
      },
    },
  },

  Erlang: {
    "Selection Based": {
      command: "erl",
      args(context) {
        return ["-noshell", "-eval", `${context.getCode()}, init:stop().`]
      },
    },
  },

  "F*": {
    "File Based": {
      command: "fstar",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  "F#": {
    "File Based": {
      command: windows ? "fsi" : "fsharpi",
      args({ filepath }) {
        return ["--exec", filepath]
      },
    },
  },

  Forth: {
    "File Based": {
      command: "gforth",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Gherkin: {
    "File Based": {
      command: "cucumber",
      args({ filepath }) {
        return ["--color", filepath]
      },
    },
    "Line Number Based": {
      command: "cucumber",
      args(context) {
        return ["--color", context.fileColonLine()]
      },
    },
  },

  Go: {
    "File Based": {
      command: "go",
      workingDirectory: GrammarUtils.workingDirectory(),
      args({ filepath }) {
        if (filepath.match(/_test.go/)) {
          return ["test", ""]
        } else {
          return ["run", filepath]
        }
      },
    },
  },

  Groovy: {
    "Selection Based": {
      command: "groovy",
      args(context) {
        return ["-e", context.getCode()]
      },
    },
    "File Based": {
      command: "groovy",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Hy: {
    "Selection Based": {
      command: "hy",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.createTempFileWithCode(code, ".hy")
        return [tmpFile]
      },
    },
    "File Based": {
      command: "hy",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Idris: {
    "File Based": {
      command: "idris",
      args({ filepath }) {
        return [filepath, "-o", path.basename(filepath, path.extname(filepath))]
      },
    },
  },

  InnoSetup: {
    "File Based": {
      command: "ISCC.exe",
      args({ filepath }) {
        return ["/Q", filepath]
      },
    },
  },

  ioLanguage: {
    "Selection Based": {
      command: "io",
      args(context) {
        return [context.getCode()]
      },
    },
    "File Based": {
      command: "io",
      args({ filepath }) {
        return ["-e", filepath]
      },
    },
  },

  Jolie: {
    "File Based": {
      command: "jolie",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Julia: {
    "Selection Based": {
      command: "julia",
      args(context) {
        return ["-e", context.getCode()]
      },
    },
    "File Based": {
      command: "julia",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  LAMMPS: ["darwin", "linux"].includes(os)
    ? {
        "File Based": {
          command: "lammps",
          args({ filepath }) {
            return ["-log", "none", "-in", filepath]
          },
        },
      }
    : undefined,

  LilyPond: {
    "File Based": {
      command: "lilypond",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  LiveScript: {
    "Selection Based": {
      command: "lsc",
      args(context) {
        return ["-e", context.getCode()]
      },
    },
    "File Based": {
      command: "lsc",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Makefile: {
    "Selection Based": {
      command: "bash",
      args(context) {
        return ["-c", context.getCode()]
      },
    },

    "File Based": {
      command: "make",
      args({ filepath }) {
        return ["-f", filepath]
      },
    },
  },

  MATLAB: {
    "Selection Based": {
      command: "matlab",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.MATLAB.createTempFileWithCode(code)
        return [
          "-nodesktop",
          "-nosplash",
          "-r",
          `try, run('${tmpFile}'); while ~isempty(get(0,'Children')); pause(0.5); end; catch ME; disp(ME.message); exit(1); end; exit(0);`,
        ]
      },
    },
    "File Based": {
      command: "matlab",
      args({ filepath }) {
        return [
          "-nodesktop",
          "-nosplash",
          "-r",
          `try run('${filepath}'); while ~isempty(get(0,'Children')); pause(0.5); end; catch ME; disp(ME.message); exit(1); end; exit(0);`,
        ]
      },
    },
  },

  "MIPS Assembler": {
    "File Based": {
      command: "spim",
      args({ filepath }) {
        return ["-f", filepath]
      },
    },
  },

  NCL: {
    "Selection Based": {
      command: "ncl",
      args(context) {
        const code = `${context.getCode()}\n\nexit`
        const tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
      },
    },
    "File Based": {
      command: "ncl",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Nim: {
    "File Based": {
      command,
      args({ filepath }) {
        const file = GrammarUtils.Nim.findNimProjectFile(filepath)
        const dir = GrammarUtils.Nim.projectDir(filepath)
        const commands = `cd '${dir}' && nim c --hints:off --parallelBuild:1 -r '${file}' 2>&1`
        return GrammarUtils.formatArgs(commands)
      },
    },
  },
  NSIS: {
    "Selection Based": {
      command: "makensis",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
      },
    },
    "File Based": {
      command: "makensis",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Octave: {
    "Selection Based": {
      command: "octave",
      args(context) {
        const dir = path.dirname(context.filepath)
        return ["-p", path.dirname(context.filepath), "--eval", context.getCode()]
      },
    },
    "File Based": {
      command: "octave",
      args({ filepath }) {
        return ["-p", path.dirname(filepath), filepath]
      },
    },
  },

  Oz: {
    "Selection Based": {
      command: "ozc",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.createTempFileWithCode(code)
        return ["-c", tmpFile]
      },
    },
    "File Based": {
      command: "ozc",
      args({ filepath }) {
        return ["-c", filepath]
      },
    },
  },

  Pascal: {
    "Selection Based": {
      command: "fpc",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
      },
    },
    "File Based": {
      command: "fpc",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Povray: {
    "File Based": {
      command,
      args({ filepath }) {
        const commands = windows ? "pvengine /EXIT /RENDER " : "povray "
        return GrammarUtils.formatArgs(commands + filepath)
      },
    },
  },

  Prolog: {
    "File Based": {
      command,
      args({ filepath }) {
        const dir = path.dirname(filepath)
        const commands = `cd '${dir}'; swipl -f '${filepath}' -t main --quiet`
        return GrammarUtils.formatArgs(commands)
      },
    },
  },
  PureScript: {
    "File Based": {
      command,
      args({ filepath }) {
        const dir = path.dirname(filepath)
        return GrammarUtils.formatArgs(`cd '${dir}' && pulp run`)
      },
    },
  },
  R: {
    "Selection Based": {
      command: "Rscript",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.R.createTempFileWithCode(code)
        return [tmpFile]
      },
    },
    "File Based": {
      command: "Rscript",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Racket: {
    "Selection Based": {
      command: "racket",
      args(context) {
        return ["-e", context.getCode()]
      },
    },
    "File Based": {
      command: "racket",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  "Ren'Py": {
    "File Based": {
      command: "renpy",
      args({ filepath }) {
        return [filepath.substr(0, filepath.lastIndexOf("/game"))]
      },
    },
  },

  "Robot Framework": {
    "File Based": {
      command: "robot",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Rust: {
    "File Based": {
      command,
      args({ filepath, filename }) {
        if (windows) {
          return [`/c rustc ${filepath} && ${filename.slice(0, Number(-4) + 1 || undefined)}.exe`]
        } else {
          const tempOutFile = GrammarUtils.createTempPath("rs-", ".out")
          return ["-c", `rustc '${filepath}' -o ${tempOutFile} && ${tempOutFile}`]
        }
      },
    },
  },
  Scala: {
    "Selection Based": {
      command: "scala",
      args(context) {
        return ["-e", context.getCode()]
      },
    },
    "File Based": {
      command: "scala",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Stata: {
    "Selection Based": {
      command: "stata",
      args(context) {
        return ["do", context.getCode()]
      },
    },
    "File Based": {
      command: "stata",
      args({ filepath }) {
        return ["do", filepath]
      },
    },
  },

  Turing: {
    "File Based": {
      command: "turing",
      args({ filepath }) {
        return ["-run", filepath]
      },
    },
  },

  "x86 and x86_64 Assembly": {
    "File Based": {
      command: "bash",
      args({ filepath }) {
        const tempOutOFile = GrammarUtils.createTempPath("asm-", ".out.o")
        const tempOutFile = GrammarUtils.createTempPath("asm-", ".out")
        let cmadArgs = ""
        switch (arch) {
          case "x32":
            cmadArgs = `nasm -f elf '${filepath}' -o ${tempOutOFile} && ld -m elf_i386 ${tempOutOFile} -o ${tempOutFile} && ${tempOutFile}`
            break
          case "x64":
            cmadArgs = `nasm -f elf64 '${filepath}' -o ${tempOutOFile} && ld ${tempOutOFile} -o ${tempOutFile} && ${tempOutFile}`
            break
          default: {
            atom.notifications.addError(`Not supported on ${arch}`)
          }
        }
        return ["-c", cmadArgs]
      },
    },

    "Selection Based": {
      command: "bash",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.createTempFileWithCode(code, ".asm")
        const tempOutOFile = GrammarUtils.createTempPath("asm-", ".out.o")
        const tempOutFile = GrammarUtils.createTempPath("asm-", ".out")
        let cmdArgs = ""
        switch (arch) {
          case "x32":
            cmdArgs = `nasm -f elf '${tmpFile}' -o ${tempOutOFile} && ld -m elf_i386 ${tempOutOFile} -o ${tempOutFile} && ${tempOutFile}`
            break
          case "x64":
            cmdArgs = `nasm -f elf64 '${tmpFile}' -o ${tempOutOFile} && ld ${tempOutOFile} -o ${tempOutFile} && ${tempOutFile}`
            break
          default: {
            atom.notifications.addError(`Not supported on ${arch}`)
          }
        }
        return ["-c", cmdArgs]
      },
    },
  },
}
export default OtherGrammars
