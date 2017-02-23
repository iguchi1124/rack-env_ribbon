gulp      = require 'gulp'
clean     = require 'gulp-clean'
rename    = require 'gulp-rename'
minifyCss = require 'gulp-minify-css'

path = 'vendor/assets/stylesheets/'

gulp.task 'clean', ->
  gulp.src(path).pipe clean(force: true)

gulp.task 'build', ->
  gulp.src('node_modules/github-fork-ribbon-css/gh-fork-ribbon.css')
    .pipe(rename('env_ribbon.css'))
    .pipe(minifyCss())
    .pipe(gulp.dest(path))
