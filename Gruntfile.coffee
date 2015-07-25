module.exports = (grunt) ->
  require('time-grunt')(grunt)
  # configurable paths
  pkg = grunt.file.readJSON("package.json")
  myConfig = {}
  myConfig.projectName = pkg.name
  myConfig.mainScript = myConfig.projectName+".coffee"
  myConfig.mainCompiledScript = myConfig.projectName+".last.js"
  myConfig.mainMinimizedCompiledScript = myConfig.projectName+".last.min.js"
  myConfig.mainMinimizedPretyCompiledScript = myConfig.projectName+".last.min.prety.js"
  myConfig.testScript = "test/"+myConfig.projectName+"-test.coffee"
  myConfig.testCompiledScript = "test/"+myConfig.projectName+"-test.js"
  myConfig.helpersTestScript = "test/helpers-"+myConfig.projectName+"-test.coffee"
  myConfig.helpersTestCompiledScript = "test/helpers-"+myConfig.projectName+"-test.js"
  myConfig.testMinimizedHtml = "test/"+myConfig.projectName+"-test-minimized.html"
  myConfig.testUnminimizedHtml = "test/"+myConfig.projectName+"-test-unminimized.html"

  grunt.initConfig
    cf: myConfig
    pkg: pkg

    coffee :
      main:
        files:
          '<%= cf.mainCompiledScript %>': '<%= cf.mainScript %>'
        options:
          bare:true
      mainTest:
        files:
          '<%= cf.testCompiledScript %>': '<%= cf.testScript %>'
      helpersmainTest:
        files:
          '<%= cf.helpersTestCompiledScript %>': '<%= cf.helpersTestScript %>'

    "string-replace":
      version:
        files: {'<%= cf.mainCompiledScript %>':'<%= cf.mainCompiledScript %>'}
        options:
          replacements: [
            pattern: /{{ VERSION }}/g
            replacement: "<%= pkg.version %>"
          ]

    copy:
      dist:
        src: '<%= cf.mainMinimizedCompiledScript %>'
        dest: 'dist/<%= cf.projectName %>.<%= pkg.version %>.min.js'

    closurecompiler:
      minify:
        files:
          '<%= cf.mainMinimizedCompiledScript %>': [ '<%= cf.mainCompiledScript %>']

        options:
          compilation_level: "ADVANCED_OPTIMIZATIONS"
          max_processes: 5
          externs: ["externs_closure/jquery.js"]
          # banner: "/* hello world! */"
      pretymin:
        files:
          '<%= cf.mainMinimizedPretyCompiledScript %>': [ '<%= cf.mainCompiledScript %>' ]
        options:
          compilation_level: "ADVANCED_OPTIMIZATIONS"
          Formatting: "PRETTY_PRINT",
          max_processes: 5
          externs: ["externs_closure/jquery.js"]
          # banner: "/* hello world! */"

    qunit:
      unminimized: [ '<%= cf.testUnminimizedHtml %>' ]
      minimized: [ '<%= cf.testMinimizedHtml %>' ]

    watch :
      main:
        files: [ '<%= cf.mainScript %>' ]
        tasks: [ "coffee:main","qunit:unminimized" ]

      mainTest:
        files: [ '<%= cf.testScript %>' ]
        tasks: [ "coffee:mainTest","qunit:unminimized" ]

      helpersmainTest:
        files: [ '<%= cf.helpersTestScript %>' ]
        tasks: [ "coffee:helpersmainTest","qunit:unminimized" ]

      test:
        files: [ '<%= cf.testUnminimizedHtml %>' ]
        tasks: [ "qunit:unminimized" ]

    clean:
      build:['<%= cf.mainCompiledScript %>',
              '<%= cf.testCompiledScript %>',
              '<%= cf.helpersTestCompiledScript %>',
              '<%= cf.mainMinimizedCompiledScript %>',
              '<%= cf.mainMinimizedPretyCompiledScript %>'
            ]

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
  # grunt.loadNpmTasks 'clean-pattern'

  # grunt.registerTask "optimize", [ 'smushit' ]
  grunt.registerTask "comp", [ "coffee:main" ]
  grunt.registerTask "addversion", [ "string-replace:version" ]
  grunt.registerTask "test", [ "qunit:unminimized" ]
  grunt.registerTask "default", [ "coffee","addversion","closurecompiler","qunit:minimized","copy:dist","clean:build" ]


