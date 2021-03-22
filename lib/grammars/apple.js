"use babel"

export const AppleScript = {
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

export const Swift = {
  "File Based": {
    command: "swift",
    args({ filepath }) {
      return [filepath]
    },
  },
}
