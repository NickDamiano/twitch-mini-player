module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    coffee:
      glob_to_multiple:
        options:
          bare: true
        expand: true
        flatten: true
        cwd: 'app/coffee'
        src: ['*.coffee']
        dest: 'app/js'
        ext: '.js'

    compass:
      app:
        options:
          environment: 'production'
          basePath: 'app'
          sassDir: 'sass'
          cssDir: 'css'
          outputStyle: 'nested'

    watch:
      options:
        spawn: false
      build:
        files: [
          'app/sass/**/*.sass'
          'app/coffee/**/*.coffee'
        ]
        tasks: 'build'

    clean:
      css:
        src: 'app/css/**/*.css'
      js:
        src: 'app/js/**/*.js'
      dist:
        src: 'dist'

    compress:
      main:
        options:
          mode: 'zip'
          archive: ->
            manifest = grunt.file.readJSON('app/manifest.json')
            return 'dist/' + manifest.name + ' (' + manifest.version + ').zip'
        files: [
          expand: true
          src: [
            'app/**/*'
            '!app/coffee'
            '!app/coffee/**/*'
            '!app/sass'
            '!app/sass/**/*'
          ]
        ]



  grunt.registerTask 'build', ['clean', 'coffee', 'compass']
  grunt.registerTask 'pack', ['build', 'compress']
