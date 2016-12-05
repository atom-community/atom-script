'use babel';

let linkPaths;
const regex = new RegExp('\
((?:\\w:)?/?\
(?:[-\\w.]+/)*[-\\w.]+)\
:(\\d+)\
(?::(\\d+))?\
', 'g');
const template = '<a class="-linked-path" data-path="$1" data-line="$2" data-column="$3">$&</a>';

export default linkPaths = lines => lines.replace(regex, template);

linkPaths.listen = parentView =>
  parentView.on('click', '.-linked-path', function (event) {
    const el = this;
    let { path, line, column } = el.dataset;
    line = Number(line) - 1;
    // column number is optional
    column = column ? Number(column) - 1 : 0;

    return atom.workspace.open(path, {
      initialLine: line,
      initialColumn: column,
    });
  })
;
