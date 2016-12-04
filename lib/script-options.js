_ = require 'underscore'

module.exports =
class ScriptOptions
  name: ''
  description: ''
  lang: ''
  workingDirectory: null
  cmd: null
  cmdArgs: []
  env: null
  scriptArgs: []

  @createFromOptions: (name, options) ->
    so = new ScriptOptions
    so.name = name
    so[key] = value for key, value of options
    so

  toObject: ->
    name: @name
    description: @description
    lang: @lang
    workingDirectory: @workingDirectory
    cmd: @cmd
    cmdArgs: @cmdArgs
    env: @env
    scriptArgs: @scriptArgs

  # Public: Serializes the user specified environment vars as an {object}
  # TODO: Support shells that allow a number as the first character in a variable?
  #
  # Returns an {Object} representation of the user specified environment.
  getEnv: ->
    return {} if not @env? or @env is ''

    mapping = {}

    for pair in @env.trim().split(';')
      [key, value] = pair.split('=', 2)
      mapping[key] = "#{value}".replace /"((?:[^"\\]|\\"|\\[^"])+)"/, '$1'
      mapping[key] = mapping[key].replace /'((?:[^'\\]|\\'|\\[^'])+)'/, '$1'


    mapping

  # Public: Merges two environment objects
  #
  # otherEnv - The {Object} to extend the parsed environment by
  #
  # Returns the merged environment {Object}.
  mergedEnv: (otherEnv) ->
    otherCopy = _.extend {}, otherEnv
    mergedEnv = _.extend otherCopy, @getEnv()

    for key,value of mergedEnv
      mergedEnv[key] = "#{value}".replace /"((?:[^"\\]|\\"|\\[^"])+)"/, '$1'
      mergedEnv[key] = mergedEnv[key].replace /'((?:[^'\\]|\\'|\\[^'])+)'/, '$1'

    mergedEnv
