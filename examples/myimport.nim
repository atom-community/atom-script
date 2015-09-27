# This is an import file for testing project file handling with script run
# for a nim file. Calling script run with this as active tab should run
# hello.nim because it is the first file in the directory with an accompanion
# config file.

proc myEcho*(s: string) =
  echo "My included echo says: ", s

when isMainModule:
  echo "I am first but that would be wrong!"
