"use babel"

const RubyGrammars = {
  RSpec: {
    "Selection Based": {
      command: "ruby",
      args(context) {
        return ["-e", context.getCode()]
      },
    },

    "File Based": {
      command: "rspec",
      args({ filepath }) {
        return ["--tty", "--color", filepath]
      },
    },

    "Line Number Based": {
      command: "rspec",
      args(context) {
        return ["--tty", "--color", context.fileColonLine()]
      },
    },
  },

  Ruby: {
    "Selection Based": {
      command: "ruby",
      args(context) {
        return ["-e", context.getCode()]
      },
    },

    "File Based": {
      command: "ruby",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  "Ruby on Rails": {
    "Selection Based": {
      command: "rails",
      args(context) {
        return ["runner", context.getCode()]
      },
    },

    "File Based": {
      command: "rails",
      args({ filepath }) {
        return ["runner", filepath]
      },
    },
  },
}
export default RubyGrammars
