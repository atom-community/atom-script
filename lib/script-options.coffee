_ = require 'underscore'
envVars = require './env-vars'

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
    return {} if not @env? or @env is ''

    mapping = {}

    try
      json = envVars.parse(@env)
    catch error
      console.error "[script]: Encountered an error parsing the environment \
        string \"#{@env}\"\n[script]: #{error}"
    finally
      json = '[]' if error

    vars = JSON.parse(json)
    for pair in vars when pair.length isnt 0
      for k,v of pair
        mapping[k] = v

    mapping

  # Public: Merges two environment objects
  #
  # otherEnv - The {Object} to extend the parsed environment by
  #
  # Returns the merged environment {Object}.
  mergedEnv: (otherEnv) ->
    otherCopy = _.extend {}, otherEnv
    _.extend otherCopy, @getEnv()
