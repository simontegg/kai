var gulp = require('gulp')
var concat = require('gulp-concat')
var compress = require('gulp-yuicompressor')
var autoprefixer = require('autoprefixer')
var cssnano = require('cssnano')
var atImport = require('postcss-import')

var appCssPaths = [
  'web/static/css/**/*.css*',
]

var vendorCssPaths = [
  'web/static/vendor/admin_lte2.css',
]

var jsBeforePaths = [
]

var jsAfterPaths = [
  'deps/phoenix/priv/static/phoenix.js',
  'deps/phoenix_html/priv/static/phoenix_html.js',
  'web/static/js/**/*.js*',
  'web/static/vendor/**/*.js*',
]

var otherAssetPaths = [
  'web/static/assets/**/*',
]

function reportChange(event) {
  console.log('File ' + event.path + ' was ' + event.type + ', running tasks...')
}

//==================TASKS=====================

gulp.task('css-vendor', function() {
  return gulp
    .src(vendorCssPaths)
    .pipe(concat('admin_lte2.css'))
    .pipe(compress({
      type: 'css'
    }))
    .pipe(gulp.dest('priv/static/css'))
})

gulp.task('css-app', function() {
  var processors = [
    atImport(),
    autoprefixer({browsers: ['last 1 version']}),
    cssnano(),
  ]

  return gulp
    .src(appCssPaths)
    .pipe(postcss(processors))
    .pipe(gulp.dest('priv/static/css'))
})

gulp.task('js-before', function() {
  return gulp
    .src(jsBeforePaths)
    .pipe(concat('app-before.js'))
    .pipe(compress({
      type: 'js'
    }))
    .pipe(gulp.dest('priv/static/js'))
})

gulp.task('js-after', function() {
  return gulp
    .src(jsAfterPaths)
    .pipe(concat('app-after.js'))
    .pipe(compress({
      type: 'js'
    }))
    .pipe(gulp.dest('priv/static/js'))
})

gulp.task('assets', function() {
  return gulp
    .src(otherAssetPaths)
    .pipe(gulp.dest('priv/static'))
})

gulp.task('default', [
  'assets',
  'css-vendor',
  'css-app',
  'js-before',
  'js-after',
])


//==================WATCHERS=====================

gulp.task('watch', function() {

  // CSS / SASS
  gulp.watch(vendorCssPaths, ['css-vendor']).on('change', reportChange)
  gulp.watch(appCssPaths, ['css-app']).on('change', reportChange)

  // JS
  gulp.watch(jsBeforePaths, ['js-before']).on('change', reportChange)
  gulp.watch(jsAfterPaths, ['js-after']).on('change', reportChange)

  // Other assets
  gulp.watch([
    'web/static/assets/**/*'
  ], ['assets']).on('change', reportChange)

})