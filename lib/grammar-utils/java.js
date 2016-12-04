'use babel';
// Java script preparation functions
import os from 'os';
import path from 'path';

export default {
  // Public: Get atom temp file directory
  //
  // Returns {String} containing atom temp file directory
  tempFilesDir: path.join(os.tmpdir()),

  // Public: Get class name of file in context
  //
  // * `filePath`  {String} containing file path
  //
  // Returns {String} containing class name of file
  getClassName(context) {
    return context.filename.replace(/\.java$/, "");
  },

  // Public: Get project path of context
  //
  // * `context`  {Object} containing current context
  //
  // Returns {String} containing the matching project path
  getProjectPath(context) {
    let projectPaths = atom.project.getPaths();
    return (() => {
      let result = [];
      for (let projectPath of projectPaths) {
        let item;
        if (context.filepath.includes(projectPath)) {
          item = projectPath;
        }
        result.push(item);
      }
      return result;
    })();
  },

  // Public: Get package of file in context
  //
  // * `context`  {Object} containing current context
  //
  // Returns {String} containing class of contextual file
  getClassPackage(context) {
    let projectPath = module.exports.getProjectPath(context);
    let projectRemoved = (context.filepath.replace(projectPath + "/", ""));
    return projectRemoved.replace(`/${context.filename}`, "");
  }
};
