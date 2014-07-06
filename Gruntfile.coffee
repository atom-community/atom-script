module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    jison:
      files:
        'env-vars2.js': 'env-vars.jison'

  # Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks 'grunt-jison'

  # Default task(s).
  grunt.registerTask 'default', ['jison']
