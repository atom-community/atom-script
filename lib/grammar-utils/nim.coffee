# Public: GrammarUtils.Nim - a module which selects the right file to run for Nim projects
module.exports =
  # Public: Find the right file to run
  #
  # * `file`    A {String} containing the current editor file
  #
  # Returns the {String} filepath of file to run

  findNimProjectFile: (editorfile) ->
    path = require('path')
    fs = require('fs')

    # check if we are running on a file
    # with config
    try
      stats = fs.statSync(editorfile + "s")
      return editorfile

    try
      stats = fs.statSync(editorfile + ".cfg")
      return editorfile

    try
      stats = fs.statSync(editorfile + "cfg")
      return editorfile

    # assume we want to run a project
    # searching for the first file which has
    # a config file with the same name and
    # run this instead of the one in the editor
    # tab
    filepath = path.dirname(editorfile)
    files = fs.readdirSync(filepath)
    files.sort()
    for file in files
      name = filepath + '/' + file
      if (fs.statSync(name).isFile())
          if(path.extname(name)=='.nims' or
            path.extname(name)=='.nimcgf' or
            path.extname(name)=='.cfg')
              try
                tfile = name.slice(0, -1)
                stats = fs.statSync(tfile)
                return tfile
              catch error
                console.log "File does not exist.";

    # just run what we got
    return editorfile
