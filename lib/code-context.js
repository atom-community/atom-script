'use babel';

export default class CodeContext {
  static initClass() {
    this.prototype.filename = null;
    this.prototype.filepath = null;
    this.prototype.lineNumber = null;
    this.prototype.shebang = null;
    this.prototype.textSource = null;
  }

  // Public: Initializes a new {CodeContext} object for the given file/line
  //
  // @filename   - The {String} filename of the file to execute.
  // @filepath   - The {String} path of the file to execute.
  // @textSource - The {String} text to under "Selection Based". (default: null)
  //
  // Returns a newly created {CodeContext} object.
  constructor(filename, filepath, textSource = null) {
    this.filename = filename;
    this.filepath = filepath;
    this.textSource = textSource;
  }

  // Public: Creates a {String} representation of the file and line number
  //
  // fullPath - Whether to expand the file path. (default: true)
  //
  // Returns the "file colon line" {String}.
  fileColonLine(fullPath = true) {
    if (fullPath) {
      var fileColonLine = this.filepath;
    } else {
      var fileColonLine = this.filename;
    }

    if (!this.lineNumber) { return fileColonLine; }
    return `${fileColonLine}:${this.lineNumber}`;
  }

  // Public: Retrieves the text from whatever source was given on initialization
  //
  // prependNewlines - Whether to prepend @lineNumber newlines (default: true)
  //
  // Returns the code selection {String}
  getCode(prependNewlines = true) {
    const code = __guard__(this.textSource, x => x.getText());
    if (!prependNewlines || !this.lineNumber) { return code; }

    const newlineCount = Number(this.lineNumber);
    const newlines = Array(newlineCount).join('\n');
    return `${newlines}${code}`;
  }

  // Public: Retrieves the command name from @shebang
  //
  // Returns the {String} name of the command or {undefined} if not applicable.
  shebangCommand() {
    const sections = this.shebangSections();
    if (!sections) { return; }

    return sections[0];
  }

  // Public: Retrieves the command arguments (such as flags or arguments to
  // /usr/bin/env) from @shebang
  //
  // Returns the {String} name of the command or {undefined} if not applicable.
  shebangCommandArgs() {
    const sections = this.shebangSections();
    if (!sections) { return []; }

    return sections.slice(1, sections.length - 1 + 1 || undefined);
  }

  // Public: Splits the shebang string by spaces to extra the command and
  // arguments
  //
  // Returns the {String} name of the command or {undefined} if not applicable.
  shebangSections() {
    return __guard__(this.shebang, x => x.split(' '));
  }
}
CodeContext.initClass();

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
