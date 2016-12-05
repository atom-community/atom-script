'use babel';

/* eslint-disable no-underscore-dangle */
import ScriptOptions from '../lib/script-options';

describe('ScriptOptions', () => {
  beforeEach(() => {
    this.scriptOptions = new ScriptOptions();
    this.dummyEnv = {
      SCRIPT_CI: 'true',
      SCRIPT_ENV: 'test',
      _NUMBERS: '123',
    };
    this.dummyEnvString = "SCRIPT_CI=true;SCRIPT_ENV='test';_NUMBERS=\"123\"";
  });

  describe('getEnv', () => {
    it('should default to an empty env object', () => {
      const env = this.scriptOptions.getEnv();
      expect(env).toEqual({});
    });

    it('should parse a custom user environment', () => {
      this.scriptOptions.env = this.dummyEnvString;
      const env = this.scriptOptions.getEnv();
      expect(env).toEqual(this.dummyEnv);
    });
  });

  describe('mergedEnv', () => {
    it('should default to the orignal env object', () => {
      const mergedEnv = this.scriptOptions.mergedEnv(this.dummyEnv);
      expect(mergedEnv).toEqual(this.dummyEnv);
    });

    it('should retain the original environment', () => {
      this.scriptOptions.env = "TEST_VAR_1=one;TEST_VAR_2=\"two\";TEST_VAR_3='three'";
      const mergedEnv = this.scriptOptions.mergedEnv(this.dummyEnv);
      expect(mergedEnv.SCRIPT_CI).toEqual('true');
      expect(mergedEnv.SCRIPT_ENV).toEqual('test');
      expect(mergedEnv._NUMBERS).toEqual('123');
      expect(mergedEnv.TEST_VAR_1).toEqual('one');
      expect(mergedEnv.TEST_VAR_2).toEqual('two');
      expect(mergedEnv.TEST_VAR_3).toEqual('three');
    });

    it('should support special character values', () => {
      this.scriptOptions.env = "TEST_VAR_1=o-n-e;TEST_VAR_2=\"nested\\\"doublequotes\\\"\";TEST_VAR_3='nested\\'singlequotes\\'';TEST_VAR_4='s p a c e s'";
      const mergedEnv = this.scriptOptions.mergedEnv(this.dummyEnv);
      expect(mergedEnv.TEST_VAR_1).toEqual('o-n-e');
      expect(mergedEnv.TEST_VAR_2).toEqual('nested\\"doublequotes\\"');
      expect(mergedEnv.TEST_VAR_3).toEqual("nested\\'singlequotes\\'");
      expect(mergedEnv.TEST_VAR_4).toEqual('s p a c e s');
    });
  });
});
