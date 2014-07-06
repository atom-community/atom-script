#!/usr/bin/env ruby -v -w -W2
# -v  -- print the Ruby version
# -w  -- warn on syntax errors
# -W2 -- warning set the warning level to 2 (verbose)

# Print the "program arguments" given by atom-script
print "ARGV was: #{ARGV}"

# This should generate a syntax Ruby warning before the script even runs when
# the command line flags above are taken into account.
'string'.match /foo bar/
