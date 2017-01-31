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
    return context.filename.replace(/\.java$/, '');
  },

  // Public: Get project path of context
  //
  // * `context`  {Object} containing current context
  //
  // Returns {String} containing the matching project path
  getProjectPath(context) {
    const projectPaths = atom.project.getPaths();
    return projectPaths.find(projectPath => context.filepath.includes(projectPath));
  },

  // Public: Get package of file in context
  //
  // * `context`  {Object} containing current context
  //
  // Returns {String} containing class of contextual file
  getClassPackage(context) {
    const projectPath = module.exports.getProjectPath(context);
    const projectRemoved = (context.filepath.replace(`${projectPath}/`, ''));
    const filenameRemoved = projectRemoved.replace(`/${context.filename}`, '');

    // File is in root of src directory - no package
    if (filenameRemoved === projectRemoved) {
      return '';
    }

    return `${filenameRemoved}.`;
  },
};
