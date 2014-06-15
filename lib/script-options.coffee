_ = require 'underscore'

module.exports =
class ScriptOptions
  workingDirectory: null
  cmd: null
  cmdArgs: []
  env: null
  scriptArgs: []

  # Public: Serializes the user specified environment vars as an {object}
  # TODO: Support shells that allow a number as the first character in a variable?
  #
  # Returns an {Object} representation of the user specified environment.
  getEnv: ->
    return {} unless @env

    mapping = {}
    pairs = @env.split(';').map (pair) -> pair.split('=')
    for pair in pairs when pair[0]?.match(/^[a-zA-Z][a-zA-Z0-9_]*$/)
      key = pair[0]
      value = pair[1]?.replace(/^["'](.*)["']$/, '$1')

      # value is undefined if "=" wasn't present in the pair substring
      # value is empty if "=" was provided without a
      mapping[key] = value if value? and value isnt ''

    mapping

  # Public: Merges two environment objects
  #
  # otherEnv - The {Object} to extend the parsed environment by
  #
  # Returns the merged environment {Object}.
  mergedEnv: (otherEnv) ->
    otherCopy = _.extend {}, otherEnv
    _.extend otherCopy, @getEnv()
