"use babel"

// Require some libs used for creating temporary files
import os from "os"
import * as fs from "fs"
import path from "path"
import * as temp from "temp"
import * as rimraf from "rimraf"

// Public: GrammarUtils - utilities for determining how to run code
const GrammarUtils = {
  tempFilesDir: path.join(os.tmpdir(), "atom_script_tempfiles"),

  ensureTempDir() {
    if (!fs.existsSync(this.tempFilesDir)) {
      fs.mkdirSync(this.tempFilesDir)
    }
  },

  // Public: Create a temporary path
  //
  // Returns the {String} filepath of the new file
  createTempPath(prefix = "", extension = "") {
    this.ensureTempDir()
    return temp.path({ dir: this.tempFilesDir, prefix, suffix: extension })
  },

  // Public: Create a temporary directory
  //
  // Returns the {String} filepath of the new folder
  createTempFolder(prefix = "") {
    this.ensureTempDir()
    return temp.mkdirSync({ dir: this.tempFilesDir, prefix })
  },

  // Public: Create a temporary file with the provided code
  //
  // * `code`    A {String} containing some code
  //
  // Returns the {String} filepath of the new file
  createTempFileWithCode(code, extension = "") {
    try {
      this.ensureTempDir()
      const tempFile = temp.openSync({ dir: this.tempFilesDir, suffix: extension })
      fs.writeSync(tempFile.fd, code)
      fs.closeSync(tempFile.fd)
      return tempFile.path
    } catch (error) {
      throw new Error(`Error while creating temporary file (${error})`)
    }
  },

  // Public: Delete all temporary files and the directory created by
  // {GrammarUtils::createTempFileWithCode}
  deleteTempFiles() {
    try {
      rimraf.sync(this.tempFilesDir)
    } catch (error) {
      console.error(`Error while deleting temporary files (${error})`)
    }
  },

  // Public: Returns cmd or bash, depending on the current OS
  command: os.platform() === "win32" ? "cmd" : "bash",

  // Public: Format args for cmd or bash, depending on the current OS
  formatArgs(command) {
    if (os.platform() === "win32") {
      return [`/c ${command.replace(/["']/g, "")}`]
    }
    return ["-c", command]
  },

  /** Get workingDirectory */
  workingDirectory() {
    const textEditor = atom.workspace.getActiveTextEditor()
    if (textEditor !== undefined) {
      return textEditor.getDirectoryPath()
    }
    return process.cwd()
  },

  // Public: Get the Java helper object
  //
  // Returns an {Object} which assists in preparing java + javac statements
  Java: require("./grammar-utils/java"),

  // Public: Get the Lisp helper object
  //
  // Returns an {Object} which assists in splitting Lisp statements.
  Lisp: require("./grammar-utils/lisp"),

  // Public: Get the MATLAB helper object
  //
  // Returns an {Object} which assists in splitting MATLAB statements.
  MATLAB: require("./grammar-utils/matlab"),

  // Public: Get the OperatingSystem helper object
  //
  // Returns an {Object} which assists in writing OS dependent code.
  OperatingSystem: require("./grammar-utils/operating-system"),

  // Public: Get the R helper object
  //
  // Returns an {Object} which assists in creating temp files containing R code
  R: require("./grammar-utils/R"),

  // Public: Get the Perl helper object
  //
  // Returns an {Object} which assists in creating temp files containing Perl code
  Perl: require("./grammar-utils/perl"),

  // Public: Get the PHP helper object
  //
  // Returns an {Object} which assists in creating temp files containing PHP code
  PHP: require("./grammar-utils/php"),

  // Public: Get the Nim helper object
  //
  // Returns an {Object} which assists in selecting the right project file for Nim code
  Nim: require("./grammar-utils/nim"),

  // Public: Get the D helper object
  //
  // Returns an {Object} which assists in creating temp files containing D code
  D: require("./grammar-utils/d"),
}
export default GrammarUtils
