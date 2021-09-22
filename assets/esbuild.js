const esbuild = require('esbuild')
const sass = require ('esbuild-sass-plugin')

const bundle = true
const logLevel = process.env.ESBUILD_LOG_LEVEL || 'silent'
const watch = !!process.env.ESBUILD_WATCH

const plugins = [
  sass.sassPlugin()
]

const loader = {
  '.png': 'dataurl',
  '.woff': 'dataurl',
  '.woff2': 'dataurl',
  '.eot': 'dataurl',
  '.ttf': 'dataurl',
  '.svg': 'dataurl',
}

const promise = esbuild.build({
  entryPoints: ['js/app.js'],
  bundle,
  target: 'es2020',
  plugins,
  loader,
  outdir: '../priv/static/assets',
  logLevel,
  watch,
})

if (watch) {
  promise.then(_result => {
    process.stdin.on('close', () => {
      process.exit(0)
    })

    process.stdin.resume()
  })
}
