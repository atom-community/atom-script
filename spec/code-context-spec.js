"use babel" // TODO

/* eslint-disable no-invalid-this */
import path from "path"
import temp from "temp"
temp.track()

import CodeContext from "../lib/code-context"

describe("CodeContext", () => {
  const testFile = "test.txt"
  let testFilePath

  beforeEach(() => {
    testFilePath = path.join(temp.mkdirSync(""), testFile)
    this.codeContext = new CodeContext(testFile, testFilePath, null)
    // TODO: Test using an actual editor or a selection?
    this.dummyTextSource = {}
    this.dummyTextSource.getText = () => "print 'hello world!'"
  })

  describe("fileColonLine when lineNumber is not set", () => {
    it("returns the full filepath when fullPath is truthy", () => {
      expect(this.codeContext.fileColonLine()).toEqual(testFilePath)
      expect(this.codeContext.fileColonLine(true)).toEqual(testFilePath)
    })

    it("returns only the filename and line number when fullPath is falsy", () => {
      expect(this.codeContext.fileColonLine(false)).toEqual(testFile)
    })
  })

  describe("fileColonLine when lineNumber is set", () => {
    it("returns the full filepath when fullPath is truthy", () => {
      this.codeContext.lineNumber = 42
      expect(this.codeContext.fileColonLine()).toEqual(`${testFilePath}:42`)
      expect(this.codeContext.fileColonLine(true)).toEqual(`${testFilePath}:42`)
    })

    it("returns only the filename and line number when fullPath is falsy", () => {
      this.codeContext.lineNumber = 42
      expect(this.codeContext.fileColonLine(false)).toEqual(`${testFile}:42`)
    })
  })

  describe("getCode", () => {
    it("returns undefined if no textSource is available", () => {
      expect(this.codeContext.getCode()).toBe(null)
    })

    it("returns a string prepended with newlines when prependNewlines is truthy", () => {
      this.codeContext.textSource = this.dummyTextSource
      this.codeContext.lineNumber = 3

      const code = this.codeContext.getCode(true)
      expect(typeof code).toEqual("string")
      // Since Array#join will create newlines for one less than the the number
      // of elements line number 3 means there should be two newlines
      expect(code).toMatch("\n\nprint 'hello world!'")
    })

    it("returns the text from the textSource when available", () => {
      this.codeContext.textSource = this.dummyTextSource

      const code = this.codeContext.getCode()
      expect(typeof code).toEqual("string")
      expect(code).toMatch("print 'hello world!'")
    })
  })

  describe("shebangCommand when no shebang was found", () =>
    it("returns undefined when no shebang is found", () => {
      const lines = this.dummyTextSource.getText()
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      expect(this.codeContext.shebangCommand()).toBe(null)
    }))

  describe("shebangCommand when a shebang was found", () => {
    it("returns the command from the shebang", () => {
      const lines = "#!/bin/bash\necho 'hello from bash!'"
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      expect(this.codeContext.shebangCommand()).toMatch("bash")
    })

    it("returns /usr/bin/env as the command if applicable", () => {
      const lines = "#!/usr/bin/env ruby -w\nputs 'hello from ruby!'"
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      expect(this.codeContext.shebangCommand()).toMatch("env")
    })

    it("returns a command with non-alphabet characters", () => {
      const lines = "#!/usr/bin/python2.7\nprint 'hello from python!'"
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      expect(this.codeContext.shebangCommand()).toMatch("python2.7")
    })
  })

  describe("shebangCommandArgs when no shebang was found", () =>
    it("returns [] when no shebang is found", () => {
      const lines = this.dummyTextSource.getText()
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      expect(this.codeContext.shebangCommandArgs()).toMatch([])
    }))

  describe("shebangCommandArgs when a shebang was found", () => {
    it("returns the command from the shebang", () => {
      const lines = "#!/bin/bash\necho 'hello from bash!'"
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      expect(this.codeContext.shebangCommandArgs()).toMatch([])
    })

    it("returns the true command as the first argument when /usr/bin/env is used", () => {
      const lines = "#!/usr/bin/env ruby -w\nputs 'hello from ruby!'"
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      const args = this.codeContext.shebangCommandArgs()
      expect(args[0]).toMatch("ruby")
      expect(args).toMatch(["ruby", "-w"])
    })

    it("returns the command args when the command had non-alphabet characters", () => {
      const lines = "#!/usr/bin/python2.7\nprint 'hello from python!'"
      const firstLine = lines.split("\n")[0]
      if (firstLine.match(/^#!/)) {
        this.codeContext.shebang = firstLine
      }
      expect(this.codeContext.shebangCommandArgs()).toMatch([])
    })
  })
})
