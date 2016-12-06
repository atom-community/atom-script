'use babel';

// Require some libs used for creating temporary files
import os from 'os';
import fs from 'fs';
import path from 'path';
import uuid from 'uuid';

// Public: GrammarUtils - utilities for determining how to run code
export default {
  tempFilesDir: path.join(os.tmpdir(), 'atom_script_tempfiles'),

  // Public: Create a temporary file with the provided code
  //
  // * `code`    A {String} containing some code
  //
  // Returns the {String} filepath of the new file
  createTempFileWithCode(code, extension = '') {
    try {
      if (!fs.existsSync(this.tempFilesDir)) {
        fs.mkdirSync(this.tempFilesDir);
      }

      const tempFilePath = this.tempFilesDir + path.sep + uuid.v1() + extension;

      const file = fs.openSync(tempFilePath, 'w');
      fs.writeSync(file, code);
      fs.closeSync(file);

      return tempFilePath;
    } catch (error) {
      throw new Error(`Error while creating temporary file (${error})`);
    }
  },

  // Public: Delete all temporary files and the directory created by
  // {GrammarUtils::createTempFileWithCode}
  deleteTempFiles() {
    try {
      if (fs.existsSync(this.tempFilesDir)) {
        const files = fs.readdirSync(this.tempFilesDir);
        if (files.length) {
          files.forEach(file => fs.unlinkSync(this.tempFilesDir + path.sep + file));
        }
        return fs.rmdirSync(this.tempFilesDir);
      }
      return null;
    } catch (error) {
      throw new Error(`Error while deleting temporary files (${error})`);
    }
  },

  /* eslint-disable global-require */
  // Public: Get the Java helper object
  //
  // Returns an {Object} which assists in preparing java + javac statements
  Java: require('./grammar-utils/java'),

  // Public: Get the Lisp helper object
  //
  // Returns an {Object} which assists in splitting Lisp statements.
  Lisp: require('./grammar-utils/lisp'),

  // Public: Get the MATLAB helper object
  //
  // Returns an {Object} which assists in splitting MATLAB statements.
  MATLAB: require('./grammar-utils/matlab'),

  // Public: Get the OperatingSystem helper object
  //
  // Returns an {Object} which assists in writing OS dependent code.
  OperatingSystem: require('./grammar-utils/operating-system'),

  // Public: Get the R helper object
  //
  // Returns an {Object} which assists in creating temp files containing R code
  R: require('./grammar-utils/R'),

  // Public: Get the Perl helper object
  //
  // Returns an {Object} which assists in creating temp files containing Perl code
  Perl: require('./grammar-utils/perl'),

  // Public: Get the PHP helper object
  //
  // Returns an {Object} which assists in creating temp files containing PHP code
  PHP: require('./grammar-utils/php'),

  // Public: Get the Nim helper object
  //
  // Returns an {Object} which assists in selecting the right project file for Nim code
  Nim: require('./grammar-utils/nim'),

  // Public: Predetermine CoffeeScript compiler
  //
  // Returns an [array] of appropriate command line flags for the active CS compiler.
  CScompiler: require('./grammar-utils/coffee-script-compiler'),

  // Public: Get the D helper object
  //
  // Returns an {Object} which assists in creating temp files containing D code
  D: require('./grammar-utils/d'),
};
