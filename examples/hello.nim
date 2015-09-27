# This file is for testing running a project by using script run
# in the main file or an imported file. For this to work the project
# file needs to be the first file (alphabetically) in the directory.

import myimport

echo "Hello World"

# calling the proc which is imported
when isMainModule:
  myEcho "Main is Main.. nana na nana!"
