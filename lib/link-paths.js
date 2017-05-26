'use babel';

/* eslint-disable no-multi-str, prefer-const, func-names */

let fs = require('fs');

let linkPaths;

const regex = new RegExp('((?:\\w:)?[/\\\\]?' +
                         '(?:[-\\w.]+[/\\\\])*[-\\w.]+\\.[\\w]+)' +
                         '(?:(?:.*line |:)(\\d+))?' +
                         '(?::(\\d+))?', 'g')
// ((?:\\w:)?[/\\\\]?                     # Prefix of the path either '/' or 'C:/' (optional)
// (?:[-\\w.]+[/\\\\])*[-\\w.]+\\.[\\w]+) # The path of the file some/file/path.ext
// (?:(?:.*line |:)(\\d+))?               # Line number prefixed with a colon (optional)
// (?::(\d+))?                            # Column number prefixed with a colon (optional)

const makeLink = (text, path, line, col) => `<a class="-linked-path" 
data-path="${path}" data-line="${line}" data-column="${col}">${text}</a>`

let replaceLinks = (text, path, line, col) => {
  if (typeof line === 'undefined') {
    line = '';
  }

  if (typeof col === 'undefined') {
    col = '';
  }

  switch (atom.config.get('script.checkFiles')) {
    case 'Correct file path with extension + line number':
      if (line === '') {
        break;
      } else {
        return makeLink(text, path, line, col)
      }
    case 'Correct file path with extension + check file existance':
      if (!fs.existsSync(path)) {
        break;
      } else {
        return makeLink(text, path, line, col)
      }
    default:
    case 'Correct file path with extension':
      return makeLink(text, path, line, col)
  }

  return text;
};

export default linkPaths = lines => lines.replace(regex, replaceLinks);

linkPaths.listen = parentView =>
  parentView.on('click', '.-linked-path', function () {
    const el = this;
    let { path, line, column } = el.dataset;
    line = Number(line) - 1;
    // column number is optional
    column = column ? Number(column) - 1 : 0;

    atom.workspace.open(path, {
      initialLine: line,
      initialColumn: column,
    });
  });
