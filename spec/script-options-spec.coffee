ScriptOptions = require '../lib/script-options'

describe 'ScriptOptions', ->
  beforeEach ->
    @scriptOptions = new ScriptOptions()
    @dummyEnv =
      SCRIPT_CI: 'true'
      SCRIPT_ENV: 'test'
      _NUMBERS: '123'
    @dummyEnvString = "SCRIPT_CI=true;SCRIPT_ENV='test';_NUMBERS=\"123\""

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

    it 'should retain the original environment', ->
      @scriptOptions.env = "TEST_VAR_1=one;TEST_VAR_2=\"two\";TEST_VAR_3='three'"
      mergedEnv = @scriptOptions.mergedEnv(@dummyEnv)
      expect(mergedEnv.SCRIPT_CI).toEqual('true')
      expect(mergedEnv.SCRIPT_ENV).toEqual('test')
      expect(mergedEnv._NUMBERS).toEqual('123')
      expect(mergedEnv.TEST_VAR_1).toEqual('one')
      expect(mergedEnv.TEST_VAR_2).toEqual('two')
      expect(mergedEnv.TEST_VAR_3).toEqual('three')

    it 'should support special character values', ->
      @scriptOptions.env = "TEST_VAR_1=o-n-e;TEST_VAR_2=\"nested\\\"doublequotes\\\"\";TEST_VAR_3='nested\\\'singlequotes\\\'';TEST_VAR_4='s p a c e s'"
      mergedEnv = @scriptOptions.mergedEnv(@dummyEnv)
      expect(mergedEnv.TEST_VAR_1).toEqual('o-n-e')
      expect(mergedEnv.TEST_VAR_2).toEqual("nested\\\"doublequotes\\\"")
      expect(mergedEnv.TEST_VAR_3).toEqual("nested\\\'singlequotes\\\'")
      expect(mergedEnv.TEST_VAR_4).toEqual('s p a c e s')
