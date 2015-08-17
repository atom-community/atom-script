regex = /// (/?(?:[-\w.]+/)*[-\w.]+):(\d+):(\d+) ///g
template = '<a class="-linked-path" data-path="$1" data-line="$2" data-column="$3">$&</a>'

module.exports = linkPaths = (lines) ->
  lines.replace regex, template

linkPaths.listen = (parentView) ->
  parentView.on 'click', '.-linked-path', (event) ->
    el = this
    {path, line, column} = el.dataset
    line = Number(line)
    column = Number(column)

    atom.workspace.open path, {
      initialLine: line
      initialColumn: column
      }
