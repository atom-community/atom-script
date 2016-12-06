'use babel';

import { Emitter } from 'atom';

import CodeContext from './code-context';
import grammarMap from './grammars.coffee';

export default class CodeContextBuilder {
  constructor(emitter = new Emitter()) {
    this.emitter = emitter;
  }

  destroy() {
    this.emitter.dispose();
  }

  // Public: Builds code context for specified argType
  //
  // editor - Atom's {TextEditor} instance
  // argType - {String} with one of the following values:
  //
  // * "Selection Based" (default)
  // * "Line Number Based",
  // * "File Based"
  //
  // returns a {CodeContext} object
  buildCodeContext(editor, argType = 'Selection Based') {
    if (!editor) return null;

    const codeContext = this.initCodeContext(editor);

    codeContext.argType = argType;

    if (argType === 'Line Number Based') {
      editor.save();
    } else if (codeContext.selection.isEmpty() && codeContext.filepath) {
      codeContext.argType = 'File Based';
      if (editor && editor.isModified()) editor.save();
    }

    // Selection and Line Number Based runs both benefit from knowing the current line
    // number
    if (argType !== 'File Based') {
      const cursor = editor.getLastCursor();
      codeContext.lineNumber = cursor.getScreenRow() + 1;
    }

    return codeContext;
  }

  initCodeContext(editor) {
    const filename = editor.getTitle();
    const filepath = editor.getPath();
    const selection = editor.getLastSelection();
    const ignoreSelection = atom.config.get('script.ignoreSelection');

    // If the selection was empty or if ignore selection is on, then "select" ALL
    // of the text
    // This allows us to run on new files
    let textSource;
    if (selection.isEmpty() || ignoreSelection) {
      textSource = editor;
    } else {
      textSource = selection;
    }

    const codeContext = new CodeContext(filename, filepath, textSource);
    codeContext.selection = selection;
    codeContext.shebang = this.getShebang(editor);

    const lang = this.getLang(editor);

    if (this.validateLang(lang)) {
      codeContext.lang = lang;
    }

    return codeContext;
  }

  getShebang(editor) {
    if (process.platform === 'win32') return null;
    const text = editor.getText();
    const lines = text.split('\n');
    const firstLine = lines[0];
    if (!firstLine.match(/^#!/)) return null;

    return firstLine.replace(/^#!\s*/, '');
  }

  getLang(editor) {
    return editor.getGrammar().name;
  }

  validateLang(lang) {
    let valid = true;

    // Determine if no language is selected.
    if (lang === 'Null Grammar' || lang === 'Plain Text') {
      this.emitter.emit('did-not-specify-language');
      valid = false;

    // Provide them a dialog to submit an issue on GH, prepopulated with their
    // language of choice.
    } else if (!(lang in grammarMap)) {
      this.emitter.emit('did-not-support-language', { lang });
      valid = false;
    }

    return valid;
  }

  onDidNotSpecifyLanguage(callback) {
    return this.emitter.on('did-not-specify-language', callback);
  }

  onDidNotSupportLanguage(callback) {
    return this.emitter.on('did-not-support-language', callback);
  }
}
