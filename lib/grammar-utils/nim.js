'use babel';
// Public: GrammarUtils.Nim - a module which selects the right file to run for Nim projects
export default {
  // Public: Find the right file to run
  //
  // * `file`    A {String} containing the current editor file
  //
  // Returns the {String} filepath of file to run

  projectDir(editorfile) {
    let path = require('path');
    return path.dirname(editorfile);
  },

  findNimProjectFile(editorfile) {
    let path = require('path');
    let fs = require('fs');

    if(path.extname(editorfile)==='.nims') {
      // if we have an .nims file
      try {
        var tfile = editorfile.slice(0, -1);
        var stats = fs.statSync(tfile);
        // it has a corresponding .nim file. so thats a config file.
        // we run the .nim file instead.
        return path.basename(tfile);
      } catch (error) {
        // it has no corresponding .nim file, it is a standalone script
        return path.basename(editorfile);
      }
    }

    // check if we are running on a file with config
    try {
      var stats = fs.statSync(editorfile + "s");
      return path.basename(editorfile);
    } catch (error) {}

    try {
      var stats = fs.statSync(editorfile + ".cfg");
      return path.basename(editorfile);
    } catch (error1) {}

    try {
      var stats = fs.statSync(editorfile + "cfg");
      return path.basename(editorfile);
    } catch (error2) {}

    // assume we want to run a project
    // searching for the first file which has
    // a config file with the same name and
    // run this instead of the one in the editor
    // tab
    let filepath = path.dirname(editorfile);
    let files = fs.readdirSync(filepath);
    files.sort();
    for (let file of files) {
      let name = filepath + '/' + file;
      if (fs.statSync(name).isFile()) {
        if(path.extname(name)==='.nims' ||
          path.extname(name)==='.nimcgf' ||
          path.extname(name)==='.cfg') {
            try {
              var tfile = name.slice(0, -1);
              var stats = fs.statSync(tfile);
              return path.basename(tfile);
            } catch (error) {
              console.log("File does not exist.");
            }
          }
      }
    }

    // just run what we got
    return path.basename(editorfile);
  }
};
