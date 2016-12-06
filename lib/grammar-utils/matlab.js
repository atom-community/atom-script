'use babel';

// Require some libs used for creating temporary files
import os from 'os';
import fs from 'fs';
import path from 'path';
import uuid from 'uuid';

// Public: GrammarUtils.MATLAB - a module which assist the creation of MATLAB temporary files
export default {
  tempFilesDir: path.join(os.tmpdir(), 'atom_script_tempfiles'),

  // Public: Create a temporary file with the provided MATLAB code
  //
  // * `code`    A {String} containing some MATLAB code
  //
  // Returns the {String} filepath of the new file
  createTempFileWithCode(code) {
    try {
      if (!fs.existsSync(this.tempFilesDir)) { fs.mkdirSync(this.tempFilesDir); }

      const tempFilePath = `${this.tempFilesDir + path.sep}m${uuid.v1().split('-').join('_')}.m`;

      const file = fs.openSync(tempFilePath, 'w');
      fs.writeSync(file, code);
      fs.closeSync(file);

      return tempFilePath;
    } catch (error) {
      throw new Error(`Error while creating temporary file (${error})`);
    }
  },
};
