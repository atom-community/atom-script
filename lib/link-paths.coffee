regex = ///
  ((?:\w:)?/?            # Prefix of the path either '/' or 'C:/' (optional)
  (?:[-\w.]+/)*[-\w.]+)  # The path of the file some/file/path.ext
  :(\d+)                 # Line number prefixed with a colon
  (?::(\d+))?            # Column number prefixed with a colon (optional)
///g
template = '<a class="-linked-path" data-path="$1" data-line="$2" data-column="$3">$&</a>'

module.exports = linkPaths = (lines) ->
  lines.replace regex, template

linkPaths.listen = (parentView) ->
  parentView.on 'click', '.-linked-path', (event) ->
    el = this
    {path, line, column} = el.dataset
    line = Number(line) - 1
    # column number is optional
    column = if column then Number(column) - 1 else 0

    atom.workspace.open path, {
      initialLine: line
      initialColumn: column
    }
