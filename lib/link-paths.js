'use babel';

/* eslint-disable no-multi-str, prefer-const, func-names */
let linkPaths;
const regex = new RegExp('((?:\\w:)?/?(?:[-\\w.]+/)*[-\\w.]+):(\\d+)(?::(\\d+))?', 'g');
// ((?:\w:)?/?            # Prefix of the path either '/' or 'C:/' (optional)
// (?:[-\w.]+/)*[-\w.]+)  # The path of the file some/file/path.ext
// :(\d+)                 # Line number prefixed with a colon
// (?::(\d+))?            # Column number prefixed with a colon (optional)

const template = '<a class="-linked-path" data-path="$1" data-line="$2" data-column="$3">$&</a>';

export default linkPaths = lines => lines.replace(regex, template);

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
