'use babel';

import _ from 'underscore';

export default class ScriptOptions {
  constructor() {
    this.name = '';
    this.description = '';
    this.lang = '';
    this.workingDirectory = null;
    this.cmd = null;
    this.cmdArgs = [];
    this.env = null;
    this.scriptArgs = [];
  }

  static createFromOptions(name, options) {
    const so = new ScriptOptions();
    so.name = name;
    for (const key in options) { const value = options[key]; so[key] = value; }
    return so;
  }

  toObject() {
    return {
      name: this.name,
      description: this.description,
      lang: this.lang,
      workingDirectory: this.workingDirectory,
      cmd: this.cmd,
      cmdArgs: this.cmdArgs,
      env: this.env,
      scriptArgs: this.scriptArgs,
    };
  }

  // Public: Serializes the user specified environment vars as an {object}
  // TODO: Support shells that allow a number as the first character in a variable?
  //
  // Returns an {Object} representation of the user specified environment.
  getEnv() {
    if (!this.env) return {};

    const mapping = {};

    for (const pair of this.env.trim().split(';')) {
      const [key, value] = pair.split('=', 2);
      mapping[key] = `${value}`.replace(/"((?:[^"\\]|\\"|\\[^"])+)"/, '$1');
      mapping[key] = mapping[key].replace(/'((?:[^'\\]|\\'|\\[^'])+)'/, '$1');
    }


    return mapping;
  }

  // Public: Merges two environment objects
  //
  // otherEnv - The {Object} to extend the parsed environment by
  //
  // Returns the merged environment {Object}.
  mergedEnv(otherEnv) {
    const otherCopy = _.extend({}, otherEnv);
    const mergedEnv = _.extend(otherCopy, this.getEnv());

    for (const key in mergedEnv) {
      const value = mergedEnv[key];
      mergedEnv[key] = `${value}`.replace(/"((?:[^"\\]|\\"|\\[^"])+)"/, '$1');
      mergedEnv[key] = mergedEnv[key].replace(/'((?:[^'\\]|\\'|\\[^'])+)'/, '$1');
    }

    return mergedEnv;
  }
}
