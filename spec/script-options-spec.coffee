ScriptOptions = require '../lib/script-options'

describe 'ScriptOptions', ->
  beforeEach ->
    @scriptOptions = new ScriptOptions()
    @dummyEnv =
      NODE_ENV: 'test',
      SCRIPT_USER: 'johndoe'
    @dummyEnvString = "SCRIPT_ENV='test';SCRIPT_USER=true;_TEST_VAR='123'"

  describe 'getEnv', ->
    it 'should default to an empty env object', ->
      env = @scriptOptions.getEnv()
      expect(env).toEqual({})

    it 'should parse a custom user environment', ->
      @scriptOptions.env = @dummyEnvString
      env = @scriptOptions.getEnv()
      expect(env).toEqual

  describe 'mergedEnv', ->
    it 'should default to the orignal env object', ->
      mergedEnv = @scriptOptions.mergedEnv(@dummyEnv)
      expect(mergedEnv).toEqual(@dummyEnv)

    it 'should merge custom options', ->
      @scriptOptions.env = "VAR_1=one;VAR_2='t w o';VAR_3=\"three\""
      mergedEnv = @scriptOptions.mergedEnv(@dummyEnv)
      expect(mergedEnv.VAR_1).toEqual('one')
      expect(mergedEnv.VAR_2).toEqual('t w o')
      expect(mergedEnv.VAR_3).toEqual('three')
      expect(mergedEnv.NODE_ENV).toEqual('test')
      expect(mergedEnv.SCRIPT_USER).toEqual('johndoe')
