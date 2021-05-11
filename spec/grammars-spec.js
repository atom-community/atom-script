"use babel" // TODO

/* eslint-disable no-invalid-this */
import path from "path"
import temp from "temp"
temp.track()

import CodeContext from "../lib/code-context"
import OperatingSystem from "../lib/grammar-utils/operating-system"
import grammarMap from "../lib/grammars"

describe("grammarMap", () => {
  const testFile = "test.txt"
  let testFilePath

  beforeEach(() => {
    testFilePath = path.join(temp.mkdirSync(""), testFile)
    this.codeContext = new CodeContext(testFile, testFilePath, null)
    // TODO: Test using an actual editor or a selection?
    this.dummyTextSource = {}
    this.dummyTextSource.getText = () => ""
  })

  it("has a command and an args function set for each grammar's mode", () => {
    this.codeContext.textSource = this.dummyTextSource
    for (const lang in grammarMap) {
      const modes = grammarMap[lang]
      for (const mode in modes) {
        const commandContext = modes[mode]

        // print more info to help testing
        console.log({ lang, commandContext })

        // TODO: fix the test for linux and windows
        if (process.platform === "darwin") {
          expect(commandContext.command).toBeDefined()
        } else {
          console.warn(`This test does not work on ${process.platform}`, commandContext.command)
        }
        const argList = commandContext.args(this.codeContext)
        expect(argList).toBeDefined()
      }
    }
  })

  describe("Operating system specific runners", () => {
    beforeEach(() => {
      this.originalPlatform = OperatingSystem.platform
      this.reloadGrammar = () => {
        delete require.cache[require.resolve("../lib/grammars")]
        delete require.cache[require.resolve("../lib/grammars/index")]
        delete require.cache[require.resolve("../lib/grammars/c")]
        this.grammarMap = require("../lib/grammars")
      }
    })

    afterEach(() => {
      OperatingSystem.platform = this.originalPlatform
      this.reloadGrammar()
    })

    describe("C", () =>
      it("returns the appropriate File Based runner on Mac OS X", () => {
        OperatingSystem.platform = () => "darwin"
        this.reloadGrammar()

        const grammar = this.grammarMap.C
        const fileBasedRunner = grammar["File Based"]
        const args = fileBasedRunner.args(this.codeContext)
        expect(fileBasedRunner.command).toEqual("bash")
        expect(args[0]).toEqual("-c")
        expect(args[1]).toMatch(/^xcrun clang/)
      }))

    describe("C++", () =>
      it("returns the appropriate File Based runner on Mac OS X", () => {
        if (process.platform === "win32") {
          return
        }
        OperatingSystem.platform = () => "darwin"
        this.reloadGrammar()

        const grammar = this.grammarMap["C++"]
        const fileBasedRunner = grammar["File Based"]
        const args = fileBasedRunner.args(this.codeContext)
        expect(fileBasedRunner.command).toEqual("bash")
        expect(args[0]).toEqual("-c")
        expect(args[1]).toMatch(/^xcrun clang\+\+/)
      }))

    describe("F#", () => {
      it('returns "fsi" as command for File Based runner on Windows', () => {
        OperatingSystem.platform = () => "win32"
        this.reloadGrammar()

        const grammar = this.grammarMap["F#"]
        const fileBasedRunner = grammar["File Based"]
        const args = fileBasedRunner.args(this.codeContext)
        expect(fileBasedRunner.command).toEqual("fsi")
        expect(args[0]).toEqual("--exec")
        expect(args[1]).toEqual(this.codeContext.filepath)
      })

      it('returns "fsharpi" as command for File Based runner when platform is not Windows', () => {
        OperatingSystem.platform = () => "darwin"
        this.reloadGrammar()

        const grammar = this.grammarMap["F#"]
        const fileBasedRunner = grammar["File Based"]
        const args = fileBasedRunner.args(this.codeContext)
        expect(fileBasedRunner.command).toEqual("fsharpi")
        expect(args[0]).toEqual("--exec")
        expect(args[1]).toEqual(this.codeContext.filepath)
      })
    })

    describe("Objective-C", () =>
      it("returns the appropriate File Based runner on Mac OS X", () => {
        OperatingSystem.platform = () => "darwin"
        this.reloadGrammar()

        const grammar = this.grammarMap["Objective-C"]
        const fileBasedRunner = grammar["File Based"]
        const args = fileBasedRunner.args(this.codeContext)
        expect(fileBasedRunner.command).toEqual("bash")
        expect(args[0]).toEqual("-c")
        expect(args[1]).toMatch(/^xcrun clang/)
      }))

    describe("Objective-C++", () =>
      it("returns the appropriate File Based runner on Mac OS X", () => {
        OperatingSystem.platform = () => "darwin"
        this.reloadGrammar()

        const grammar = this.grammarMap["Objective-C++"]
        const fileBasedRunner = grammar["File Based"]
        const args = fileBasedRunner.args(this.codeContext)
        expect(fileBasedRunner.command).toEqual("bash")
        expect(args[0]).toEqual("-c")
        expect(args[1]).toMatch(/^xcrun clang\+\+/)
      }))
  })
})
