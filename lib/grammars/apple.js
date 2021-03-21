//{OperatingSystem} = require '../grammar-utils'

export let AppleScript = {
  "Selection Based": {
    command: "osascript",
    args(context) {
      return ["-e", context.getCode()]
    },
  },

  "File Based": {
    command: "osascript",
    args({ filepath }) {
      return [filepath]
    },
  },
}

export let Swift = {
  "File Based": {
    command: "swift",
    args({ filepath }) {
      return [filepath]
    },
  },
}
