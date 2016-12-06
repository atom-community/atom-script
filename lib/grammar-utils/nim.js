'use babel';

import fs from 'fs';
import path from 'path';

// Public: GrammarUtils.Nim - a module which selects the right file to run for Nim projects
export default {
  // Public: Find the right file to run
  //
  // * `file`    A {String} containing the current editor file
  //
  // Returns the {String} filepath of file to run

  projectDir(editorfile) {
    return path.dirname(editorfile);
  },

  findNimProjectFile(editorfile) {
    if (path.extname(editorfile) === '.nims') {
      // if we have an .nims file
      const tfile = editorfile.slice(0, -1);

      if (fs.existsSync(tfile)) {
        // it has a corresponding .nim file. so thats a config file.
        // we run the .nim file instead.
        return path.basename(tfile);
      }
      // it has no corresponding .nim file, it is a standalone script
      return path.basename(editorfile);
    }

    // check if we are running on a file with config
    if (fs.existsSync(`${editorfile}s`) ||
        fs.existsSync(`${editorfile}.cfg`) ||
        fs.existsSync(`${editorfile}cfg`)) {
      return path.basename(editorfile);
    }

    // assume we want to run a project
    // searching for the first file which has
    // a config file with the same name and
    // run this instead of the one in the editor
    // tab
    const filepath = path.dirname(editorfile);
    const files = fs.readdirSync(filepath);
    files.sort();
    for (const file of files) {
      const name = `${filepath}/${file}`;
      if (fs.statSync(name).isFile()) {
        if (path.extname(name) === '.nims' ||
            path.extname(name) === '.nimcgf' ||
            path.extname(name) === '.cfg') {
          const tfile = name.slice(0, -1);
          if (fs.existsSync(tfile)) return path.basename(tfile);
        }
      }
    }

    // just run what we got
    return path.basename(editorfile);
  },
};
