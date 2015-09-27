# this is a nim file to test that a file which has its own config
# does not trigger the call of the "by convention" project file.

when isMainModule:
  echo "Being a bit sad that I am second!"
