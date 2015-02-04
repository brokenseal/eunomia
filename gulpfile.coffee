gulp = require('gulp')
coffee = require('gulp-coffee')
gulpUtil = require('gulp-util')
sourceMaps = require('gulp-sourcemaps')
mocha = require('gulp-mocha')
coffeelint = require('gulp-coffeelint')
coffeeify = require('gulp-coffeeify')
uglify = require('gulp-uglify')

compileCoffeeScriptFiles = (path) ->
    gulp.src(path + '/*.coffee')
      .pipe(sourceMaps.init())
      .pipe(coffee({bare: true}).on('error', gulpUtil.log))
      .pipe(sourceMaps.write())
      .pipe(gulp.dest('dist/node/' + path))


gulp.task('coffee', ->
  # compiles all coffee script files from src to lib, adding source maps as well
  compileCoffeeScriptFiles('src')
)

gulp.task('browserify', ->
  # I will might need to go back to vanilla browserify since I can't add source maps this way
  gulp.src('src/eunomia.coffee')
    .pipe(coffeeify())
    .pipe(uglify())
    .pipe(gulp.dest('dist/browser'))
)

gulp.task('test', ->
  gulp.src([
    'test/unit/*.coffee'
  ], {read: false}).pipe(mocha({reporter: 'nyan'}))
)

gulp.task('lint', ->
  gulp.src(['*.coffee', 'src/*.coffee', 'src/**/*.coffee', 'test/*.coffee', 'test/**/*.coffee'])
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
)

gulp.task('watch', ->
  gulp.watch('**/*.coffee', ['test'])
)

gulp.task('build', ['coffee', 'browserify'], ->
  console.log('Done.')
)

gulp.task('default', ['lint', 'test', 'build'], ->
  console.log('Done.')
)
