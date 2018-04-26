gulp = require 'gulp'
merge = require 'merge-stream'
rename = require 'gulp-rename'
pug = require 'gulp-pug'
gm = require 'gulp-gm'
sourcemaps = require 'gulp-sourcemaps'
postcss = require 'gulp-postcss'
precss = require 'precss'
cssnext = require 'postcss-cssnext'
cssnano = require 'cssnano'

gulp.task 'pages', ->
	pages = gulp.src(['content/*.pug'])
		.pipe pug()
		.pipe gulp.dest('dist/')

gulp.task 'images', ->
	jpg = gulp.src(['static/**/*.jpg'])

	jpgo1 = jpg
		.pipe gm (f) ->  f.resize(768)
		.pipe rename (path) -> path.basename += '.768'

	jpgo2 = jpg
		.pipe gm (f) ->  f.resize(1536)
		.pipe rename (path) -> path.basename += '.1536'

	svg = gulp.src(['static/**/*.svg'])

	merge(jpg, jpgo1, jpgo2, svg)
		.pipe gulp.dest('dist/static/')

gulp.task 'styles', ->
	css = gulp.src(['static/**/*.css'])
		.pipe sourcemaps.init()
		.pipe(postcss([
			precss(),
			cssnext(),
			cssnano()
		]))
		.pipe sourcemaps.write('.')
		.pipe gulp.dest('dist/static/')


tasks = [
	'pages', 'images', 'styles'
]

gulp.task 'watch', gulp.parallel tasks, ->
	gulp.watch([
		'content/**/*.pug',
		'static/**/*.css',
		'static/**/*.svg',
		'static/**/*.jpg',
	], gulp.parallel('pages', 'images', 'styles'))

gulp.task 'default', gulp.parallel(tasks)
